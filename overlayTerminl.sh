#!/bin/bash

# Terminal class name
TERMINAL_CLASS="KittyOverlay"  # Change this based on your terminal class

# Check if the terminal is already running
WIN_ID=$(hyprctl clients | awk -v class='KittyOverlay' '
      /Window/ {win_id=$2}  # Capture the window ID
      /class:/ && $2 == class {print win_id}  # Match the class and print the saved ID
      ')

if [ -z "$WIN_ID" ]; then
  # Terminal is not running, launch it
  kitty --class $TERMINAL_CLASS &
else
  # Terminal is running, toggle its visibility
  hyprctl dispatch togglespecialworkspace $WIN_ID
fi