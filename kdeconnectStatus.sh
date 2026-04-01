#!/bin/bash

#this script for get the kdeconnect status and kdeconnect refresh periodically

if kdeconnect-cli -l 2>/dev/null | grep -q "paired and reachable";  then
	echo "{\"state\":\"good\",\"text\":\"📱\"}"
	kdeconnect-cli --refresh
else
	echo "{\"state\":\"critical\",\"text\":\"📱\"}"
	kdeconnect-cli --refresh
fi


