#!/bin/bash
swayidle -w \
timeout 120 ' swaylock -i ~/Downloads/822323.jpg ' \
timeout 400 ' hyprctl dispatch dpms off' \
timeout 12000 'systemctl suspend' \
resume ' hyprctl dispatch dpms on' \
before-sleep 'swaylock -i ~/Downloads/822323.jpg'