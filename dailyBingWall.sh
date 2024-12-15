#!/bin/sh

if [ ! -d ~/wallpaper ];then
	mkdir wallpaper
fi

url=$(curl "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US" \
		| jq --raw-output '.images[0].url' \
		| sed 's/&.*//g' \
		| xargs printf 'https://bing.com%s')

wget -O ~/wallpaper/wall.jpg --tries=2 "${url}"

if [ $? -eq 0 ]; then
	mv ~/wallpaper/wall.jpg ~/wallpaper/wall2.jpg
	magick ~/wallpaper/wall2.jpg ~/wallpaper/wall2.png
fi

feh --bg-fill ~/wallpaper/wall2.jpg
