#!/bin/bash

#  DateDisplay.sh  shell script to display info. for given date
function calc
{
    awk "BEGIN {print $* }";
}

DATE=$1
echo Display Dexcom Info for Date $DATE
echo Glucose:
NBR=$(mongo dexcomcgm --quiet --eval "db.glucose.find({ \"display_time\": /$DATE/ }).sort({\"display_time\": -1}).forEach(printjson)" | grep glucose | wc -l)
echo  $NBR Glucose Entries 



echo Insulin:
# basic report:
/usr/bin/mongo dexcomcgm --quiet --eval "db.treatments.find({ \"display_time\": /$DATE/, \"event_type\": \"INSULIN\" }).sort({\"display_time\": -1}).forEach(printjson)"  | grep '\(display_time\|event_value\)'
# total
TOTALINSULIN=$(/usr/bin/mongo dexcomcgm --quiet --eval "db.treatments.find({ \"display_time\": /$DATE/, \"event_type\": \"INSULIN\" }).sort({\"display_time\": -1}).forEach(printjson)"  | grep 'event_value' | awk ' {tot += $3; nl++} END {print tot;}')
echo "Total Insulin: $TOTALINSULIN"

echo

echo Meals/Calories:
# basic report: 
/usr/bin/mongo dexcomcgm --quiet --eval "db.treatments.find({ \"display_time\": /$DATE/, \"event_type\": \"CARBS\" }).sort({\"display_time\": -1}).forEach(printjson)"  | grep '\(display_time\|event_value\)'
# total Carbs:
TOTALCARBS=$(/usr/bin/mongo dexcomcgm --quiet --eval "db.treatments.find({ \"display_time\": /$DATE/, \"event_type\": \"CARBS\" }).sort({\"display_time\": -1}).forEach(printjson)"  | grep 'event_value' | awk ' {tot += $3; nl++} END {print tot;}')
echo "Total Carbs: $TOTALCARBS"

CR=$(calc $TOTALCARBS / $TOTALINSULIN)
printf "Carb Ratio: %f\n" "$CR"

#  get first and last glucose, report difference. 
GLUCOSE_1=$(mongo dexcomcgm --quiet --eval "db.glucose.find({ \"display_time\": /$DATE/ }).sort({\"display_time\": 1}).forEach(printjson)" | head -7 | grep glucose | awk '{print $3;}')
echo "Beginning BG: $GLUCOSE_1"
GLUCOSE_2=$(mongo dexcomcgm --quiet --eval "db.glucose.find({ \"display_time\": /$DATE/ }).sort({\"display_time\": -1}).forEach(printjson)" | head -7 | grep glucose | awk '{print $3;}')
echo "Ending BG: $GLUCOSE_2"

DELTA_BG=$(calc $GLUCOSE_2 - $GLUCOSE_1)
echo "Delta BG:  $DELTA_BG"
(( $DELTA_BG > 0)) && echo "Comment:  positive delta BG means too little insulin was used; CR too high?"
(( $DELTA_BG < 0)) && echo "Comment:  negative delta BG means too much   insulin was used; CR too low?"
(( $DELTA_BG == 0)) && echo "Comment:  zero delta BG means insulin was used; CR seems accurate."
## ----------------------------------------------------------------------

