#!/usr/bin/env bash
set -eu

## Use playerctl status --list-all to find the correct player
## sometimes chrome is listed as a media player
readonly primaryPlayer="rhythmbox"
readonly secondaryPlayer="spotify"

playerStatus=""
songString=""

primaryStatus=$(playerctl status --player=${primaryPlayer} 2> /dev/null)
secondaryStatus=$(playerctl status --player=${secondaryPlayer} 2> /dev/null)

# We short to the primary player regardless if others are playing
if [[ "${primaryStatus}" == "Playing" ]]; then
    songString=$(playerctl --player=${primaryPlayer} metadata --format="{{album}} - {{artist}}");
elif [[ "${secondaryStatus}" == "Playing" ]]; then
    songString=$(playerctl --player=${secondaryPlayer} metadata --format="{{album}} - {{artist}}");
fi

if [[ "${primaryStatus}" == "Playing" || "${secondaryPlayer}" == "Playing" ]]; then
    echo "${songString}"
else 
    echo ""
fi