#1/bin/bash
#for managing the idle and lock

#getting random wallpaper from ~/wallpaper
Wallpaper=""
getRandomWall(){
	 Wallpaper=~/Wallpapers/$(ls ~/Wallpapers/ | shuf -n 1)
}

screenshotAndBlur(){
	grim /tmp/ss.png && magick /tmp/ss.png -blur 0x10 /tmp/ss.png
}

#fucntion for lock
lock() {
	getRandomWall #calling random wallpaper function
	
	screenshotAndBlur

	#old swaylock command
	#swaylock -f -i $Wallpaper   #for the random wallpaper from folder
#	swaylock \
#		-F \
#		-f \
#		-i /tmp/ss.png  #for the blured screenshot
		
	#swaylock with effects command
	swaylock \
		-F \
		-f \
		--screenshots \
		--clock \
		--timestr '%I:%M:%S %p'\
		--indicator \
		--indicator-radius 100 \
		--indicator-thickness 7 \
		--effect-blur 7x5 \
		--effect-vignette 0.5:0.5 \
		--ring-color bb00cc \
		--key-hl-color 880033 \
		--line-color 00000000 \
		--inside-color 00000088 \
		--separator-color 00000000 \
		--grace 2 \
		--fade-in 0.2
}

#function for idle

idle(){
	getRandomWall #calling random wallpaper function
	
	swayidle -w \
        	timeout 60 "~/myScripts/powerAndlock.sh lock" \
        	timeout 180 'systemctl  hybrid-sleep' \
        	before-sleep "~/myScripts/powerAndlock.sh lock" 
}


lidClose(){
	~/myScripts/powerAndlock.sh lock;
	sleep 10;
	#for preventing quick open after closing crash
	#it will check still lid is closed or not only after it will go to suspend state
	if [[ $(cat /proc/acpi/button/lid/*/state | grep closed | wc -l) -eq 1  ]];then
		systemctl hybrid-sleep;
	fi
}

#reading arguments
#lock or idle or lidClose
arg=$1 

#dealing with arguments
case $arg in
	lock) lock ;;
	idle) idle ;;
	lidClose) lidClose ;;
	*) echo "Invalid option" ;;
esac



