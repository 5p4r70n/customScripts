#!/bin/bash

#logging
logfile=/tmp/wallpaperflare.log
exec > >(tee -a "$logfile") 2>&1

urls=()
urlLength=0
randomNo=0
websiteLiveStatusCode=0

#Local wallpaper directory
localWallpaperDir=~/Wallpapers/

AccessCookie="cf_clearance=tCezNZayZqhpReWYSses87WFaCJKLXOOVpSGmR7LLas-1757959726-1.2.1.1-Jq9OEttUoFlxtk_CiGVw_fyHaSnJRRcVC4U8N3zku43nxKFOQALhMFbMN_blZ8OxdwT0LZVyx6ewMPMYugrYYn5cJKXLEFkOUo3QEx1KtqhzoaEUqIa8bch9q14p4UVIOgHdXo_7xbsAi0be21ou4Yer1wHiZ9xu_93jD_sHAWjtyJo75EK1sdxUdHvCwMuxdfowVbQtAQAawfAYtwikPbwXmJHtQU6quQkK6dQYhLA"

curlHeader=(
  --compressed
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0'
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
  -H 'Accept-Language: en-GB'
  -H 'Accept-Encoding: gzip, deflate, br, zstd'
  -H 'Alt-Used: www.wallpaperflare.com'
  -H 'Connection: keep-alive'
  -H "Cookie: $AccessCookie"
  -H 'Upgrade-Insecure-Requests: 1'
  -H 'Sec-Fetch-Dest: document'
  -H 'Sec-Fetch-Mode: navigate'
  -H 'Sec-Fetch-Site: cross-site'
  -H 'Priority: u=0, i'
  -H 'TE: trailers'
)

#when the website is down or not accessible
function updateLocalFileAsWall(){
    echo "Updating local file as wallpaper"
    #get Random file from wallpaper directory
    selectedFile=$localWallpaperDir$(ls $localWallpaperDir | shuf -n 1)

    # updating the wallpaper
    swaymsg "output * bg $selectedFile fill" > /dev/null
}

#website accessible check
function websitePing(){
    echo check if website is accessible

    websiteLiveStatusCode=$(curl -s -o /dev/null -w "%{http_code}\n"  'https://www.wallpaperflare.com/' "${curlHeader[@]}")

    #caling the get website detals func
    updateUrls
    #getting the length of urls
    urlLength=${#urls[@]}
    echo $urlLength found this much wallpaper
}

function updateUrls(){
    echo grabbing the wallpapers urls
    #loding urls to array
    mapfile -t urls < <( curl -sS "https://www.wallpaperflare.com/" "${curlHeader[@]}" | grep -Eo '(https://www\.wallpaperflare\.com/.+-[^"]+)')
}

function updateWall {

    echo updating the wallpapers from website

    #getting a random no between 1- length of the array
    randomNo=$(shuf -i 1-$urlLength -n 1)

    echo $randomNo selected random no

    #getting the wallpaper fullsize url

    wallpaper=$( curl -s "${urls[$randomNo]}/download" "${curlHeader[@]}"  | grep -Eo '(https://r4\.wallpaperflare\.com/.+-[^"]+)')

    echo $wallpaper selected wallpaper url

    if [[ -z $wallpaper ]];then
        echo "wallpaper not found"
        return
    fi

    #saving the wallpaper to /tmp
    wget  -q $wallpaper -O /tmp/wall.jpg

    #for checking the wallpaper download status
    if [[ $? -ne 0 ]];then
        echo "wallpaper not found"
        websiteLiveStatusCode=0
        return
    fi

    #saving  wallpaper
    cp /tmp/wall.jpg ~/Wallpapers/$(echo $wallpaper | grep -oP '[^/]+$')

    # updating the wallpaper
    swaymsg "output * bg /tmp/wall.jpg fill" > /dev/null
}

#check the website readness
websitePing

#infinite loop that will upddate and downoad urls
while true;do

    #check website readness
    if [[ $websiteLiveStatusCode -eq 200 ]];then
        #updating function call
        updateWall;

    else
        echo website not accessible
        #checking again for website readness
        websitePing

        #seting local file as wallpaper
        updateLocalFileAsWall
    fi

    sleep 60;
done
