#!/bin/bash

urls=()
urlLength=0
randomNo=0

AccessCookie="cf_clearance=qMXjfEAvi0daDgxstPMRxzb63sbYQPeNCIiOwHnC3R4-1751457280-1.2.1.1-RgXY6dJOqEoUESCMlnQcOtgCJz8PU8pWP4VsFmDBMq_mydiqidj2cbkd5_VGeSNCcoi2GuX4m8qmRRlbAUl8c8gX.q.Q7Tv62U52h8vJiPXR8DWXIX6g_SOqv_my2Go9.4GcG19h2lHySaNWxhfU9NuSjtNSeW4Pw4RIW9zAgnKv90QQb0VmONSaZ12CKQGt91uFRSJ7_CQb2Ek3zbL8VmNGTDpU.nSw9H96n_X2.cdCzqqpJucUr3XvewOxnhNamXJa7RXqdcg9F7phJPIdnYqNNcBSynsutobSRTLrcSqDnRWUhC3n8D5sRaD9sBj1EfuZVgbvZMPXNR4vaox9uzfbl7Ltpa8iKuvG.9Kc9m8MWp3PQfPsaUNUQqwNp1XU"

test(){
    curlHeader=" --compressed \
            -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0' \
            -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
            -H 'Accept-Language: en-GB' \
            -H 'Accept-Encoding: gzip, deflate, br, zstd' \
            -H 'Connection: keep-alive' \
            -H 'Cookie: $AccessCookie ' \
            -H 'Upgrade-Insecure-Requests: 1' \
            -H 'Sec-Fetch-Dest: document' \
            -H 'Sec-Fetch-Mode: navigate' \
            -H 'Sec-Fetch-Site: cross-site' \
            -H 'Priority: u=0, i' \
            -H 'Pragma: no-cache' \
            -H 'Cache-Control: no-cache'" 
    eval "curl -sS https://www.wallpaperflare.com/ " $curlHeader
}

test
exit

updateUrls(){

    curlHeader=" --compressed \
                -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0' \
                -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
                -H 'Accept-Language: en-GB' \
                -H 'Accept-Encoding: gzip, deflate, br, zstd' \
                -H 'Connection: keep-alive' \
                -H 'Cookie: $AccessCookie ' \
                -H 'Upgrade-Insecure-Requests: 1' \
                -H 'Sec-Fetch-Dest: document' \
                -H 'Sec-Fetch-Mode: navigate' \
                -H 'Sec-Fetch-Site: cross-site' \
                -H 'Priority: u=0, i' \
                -H 'Pragma: no-cache' \
                -H 'Cache-Control: no-cache'" 

    #loding urls to array
    mapfile -t urls < <( eval "curl -sS https://www.wallpaperflare.com/ " $curlHeader | grep -Eo '(https://www\.wallpaperflare\.com/.+-[^"]+)')
    
}

#caling the get website detals func
updateUrls

#getting the length of urls 
urlLength=${#urls[@]}


echo $urlLength found this much wallpaper >> /tmp/wallpaperflare.log

function updateWall {

    #getting a random no between 1- length of the array
    randomNo=$(shuf -i 1-$urlLength -n 1)

    echo $randomNo selected random no >> /tmp/wallpaperflare.log

    #getting the wallpaper fullsize url

    wallpaper=$( eval "curl -s ${urls[$randomNo]}/download" $curlHeader  | grep -Eo '(https://r4\.wallpaperflare\.com/.+-[^"]+)')

    echo $wallpaper selected wallpaper url >> /tmp/wallpaperflare.log

    if [[ -z $wallpaper ]];then
        echo "wallpaper not found" >> /tmp/wallpaperflare.log
        return
    fi

    #saving the wallpaper to /tmp
    wget  -q $wallpaper -O /tmp/wall.jpg

    #saving  wallpaper
    cp /tmp/wall.jpg ~/Wallpapers/$(echo $wallpaper | grep -oP '[^/]+$')

    # updating the wallpaper
    swaymsg "output * bg /tmp/wall.jpg fill" > /dev/null

}

#infinite loop that will upddate and downoad urls
while true;do
    #updating function call
    updateWall;
    sleep 60;
done
