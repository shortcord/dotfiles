#!/usr/bin/env bash

## Use playerctl status --list-all to find the correct player
## sometimes chrome is listed as a media player
readonly player_name="spotify" 

readonly cover_location="/tmp/cover.jpeg"

album_art=$(playerctl --player ${player_name} metadata mpris:artUrl)

if [[ -z $album_art ]]; then
    # spotify is dead, we should die to.
    if [[ -e "${cover_location}" ]];
     rm "${cover_location}"
    fi
    exit
fi
curl -s  "${album_art}" --output "/tmp/cover.jpeg"
echo "/tmp/cover.jpeg"