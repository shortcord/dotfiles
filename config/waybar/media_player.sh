#!/usr/bin/env bash

## Use playerctl status --list-all to find the correct player
## sometimes chrome is listed as a media player
readonly player_name="spotify" 

player_status=$(playerctl status --player=${player_name} 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo "$(playerctl metadata artist --player=${player_name}) - $(playerctl metadata title --player=${player_name})"
elif [ "$player_status" = "Paused" ]; then
    echo " $(playerctl metadata artist --player=${player_name}) - $(playerctl metadata title --player=${player_name})"
fi