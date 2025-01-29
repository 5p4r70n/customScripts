#!/bin/bash

media=$(playerctl metadata --format " {{ title }}" | tr -d '"' | sed -E "s/^(.{45}).*/\1/" )

player_status=$(playerctl status)

if [[ $player_status == "Playing" ]]
then
    song_status='▶'
elif [[ $player_status == "Paused" ]]
then
    song_status='⏸'
else
    song_status=''
fi

echo "{\"icon\":\"\",\"text\":\"${song_status}${media}\"}" 