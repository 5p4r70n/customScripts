#!/bin/bash

# # Terminal class name
# TERMINAL_CLASS='KittyOverlay'  # Change this based on your terminal class

# # Check if the terminal is already running
# WIN_ID=$(hyprctl clients | awk -v class=$TERMINAL_CLASS '
#       /Window/ {win_id=$2}  # Capture the window ID
#       /class:/ && $2 == class {print win_id}  # Match the class and print the saved ID
#       ')

# # Check if a window ID was found
# if [ -n "$WIN_ID" ]; then
#   # Window ID found, toggle the special workspace
#   hyprctl dispatch togglespecialworkspace $WIN_ID
# else
#   # No matching window found, launch the terminal
#   kitty --class "$TERMINAL_CLASS" &
# fi

TERMINAL_CLASS='KittyOverlay'  # Change this based on your terminal class
kitty --class "$TERMINAL_CLASS" &
++