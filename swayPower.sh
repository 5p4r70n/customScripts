#!/bin/bash

#it is for poweroff when idle


swayidle -w \
        timeout 300 'swaylock -f -i ~/Wallpapers/wallhaven-d6y12l.jpg' \
        timeout 600 'swaymsg "output * dpms off"' \
        timeout 900 'systemctl suspend' resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f -i ~/Wallpapers/wallhaven-d6y12l.jpg'

