#!/bin/bash

#for getting blurtooth device battery status

#first parameter as battery percentage
jsonOutput(){
	if [[ $1 -lt 21 ]];then
		echo "{\"state\":\"critical\",\"text\":\"B $1\"}"
	elif [[ $1 -lt 51 ]];then
		echo "{\"state\":\"warning\",\"text\":\"B $1\"}"
	else
		#echo "{\"state\":\"good\",\"text\":\"B $1\"}"
	 	echo "{\"state\":\"good\",\"text\":\"Idle On\"}"
	fi
}

# first parameter macId
getBatteryLevel(){
	BATTERY_LEVEL=$(bluetoothctl info $1 | awk -F': ' '/Battery Per/ { print $2 }' | awk '{print $2}' | tr -d '()')	
	jsonOutput $BATTERY_LEVEL
}


CONNECTED_DEVICES=$(bluetoothctl devices Connected | wc -l);

if [[ $CONNECTED_DEVICES -eq 0 ]];then
	 echo "{\"state\":\"good\",\"text\":\"Idle On\"}"	
	#echo "{\"state\":\"good\",\"text\":\"\"}"
	#exit;
#else
	#echo "working"
fi

blListArray=$(bluetoothctl devices Connected | awk ' {print $2}');

echo ${blListArray[0]}


#for mac_id in $(bluetoothctl devices Connected | awk ' {print $2} ') ; do   
	#getBatteryLevel $mac_id;
 	#echo "{\"state\":\"good\",\"text\":\"Idle On\"}"
#done

#echo "[\"{\"state\":\"good\",\"text\":\"Idle On\"}\"]"
#echo '[{"state":"good","text":"Idle On"}]'
#echo "[{\"state\":\"good\",\"text\":\"Idle On\"}]"

