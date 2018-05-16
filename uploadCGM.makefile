#  make file to upload CGM to Mongodb
#  Uploads previous 1 week of glucose readings
#  uses and re-uses temporary file

clean:
	rm tmp.json

DexEventUpload:
	echo "Dexcom must be plugged in."
	openaps use DexcomG4 user_event_data > tmp.json && \
	jq . tmp.json && \
		mongoimport -d dexcomcgm -c treatments --jsonArray < tmp.json

DexGlucoseUpload:
	echo "Dexcom must be plugged in."
	openaps use DexcomG4 iter_glucose 2016 > tmp.json && \
	jq . tmp.json && \
	   mongoimport -d dexcomcgm -c glucose --jsonArray < tmp.json
