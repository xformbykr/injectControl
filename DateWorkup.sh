#!/bin/bash

#  DateWorkup.sh  shell script to work up data for given date:
#  marshall data and then run openAPS 'autotune'.

#  usage:  /bin/bash DateWorkup.sh <date>, e.g.,
#  /bin/bash DateWorkup.sh '2018-03-06'

DATE=$1
echo $DATE

export NODE_PATH=~/Projects/myOpenAPS

#  insert a read then stop or go step here!!
read -p "Are you sure that data for this date are OK? " ANSWER
if [ "$ANSWER" = 'n' ] ; then
	exit 0
fi 

#  bring down insulin and carbs , store in file 'tmp.json'
/usr/bin/mongoexport --db dexcomcgm --collection treatments --query \
 "{ \$query : { \"display_time\": /$DATE/ }, \$orderby: {\"display_time\": 1 }}" --jsonArray --out tmp.json

#  then rewrite for use by openaps applications
/usr/bin/perl event2bolus.pl $DATE tmp.json > ../monitor/pumphistory$DATE.json
/usr/bin/perl event2carbs.pl $DATE tmp.json > ../monitor/carbhistory$DATE.json
rm tmp.json

# bring down glucose data, store in file
/usr/bin/mongoexport --db dexcomcgm --collection glucose --query \
 "{ \$query : { \"display_time\": /$DATE/ }, \$orderby: {\"display_time\": 1 }}" --jsonArray --out tmpglucose.json

# then rewrite for use by openaps applications
/usr/bin/perl convertGlucose.pl $DATE tmpglucose.json > ../monitor/cgm_24hrs_$DATE.json
rm tmpglucose.json

#  run openaps application using files for DATE:
pushd ..
# 1 - run 'autotune-prep':
/usr/bin/nodejs    oref0/bin/oref0-autotune-prep.js \
monitor/pumphistory$DATE.json settings/profile.json \
monitor/cgm_24hrs_$DATE.json settings/pumpprofile.json \
monitor/carbhistory$DATE.json > prepped$DATE.json

# 2 - run autotune-core:
/usr/bin/nodejs  oref0/bin/oref0-autotune-core.js \
prepped$DATE.json settings/autotune.json \
settings/profile.json > settings/autotune$DATE.json

popd

## end of script
################
