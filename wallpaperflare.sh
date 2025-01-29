#!/bin/bash

urls=()
urlLength=0
randomNo=0

#loding urls to array
mapfile -t urls < <(curl -s "https://www.wallpaperflare.com/" | grep -Eo '(https://www\.wallpaperflare\.com/.+-[^"]+)')
#getting the length of urls 
urlLength=${#urls[@]}

function updateWall {

    #getting a random no between 1- length of the array
    randomNo=$(shuf -i 1-$urlLength -n 1)

    #getting the wallpaper fullsize url
    wallpaper=$(curl -s "${urls[$randomNo]}"/download | grep -Eo '(https://r4\.wallpaperflare\.com/.+-[^"]+)')

    #saving the wallpaper to /tmp
    wget  -q $wallpaper -O /tmp/wall.jpg

    # updating the wallpaper
    swaymsg "output * bg /tmp/wall.jpg fill"

}

#infinite loop that will upddate and downoad urls
while true;do
    #updating function call
    updateWall;
    sleep 60;
done
