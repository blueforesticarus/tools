#!/bin/bash
ICON=apps/spotify.png
ICONSET=Paper
ICONSIZE=48x48

if [ "$PLAYER_EVENT" = "change" ] && [ "$(playerctl status)" == "Playing" ]; then
    ARGS="$(playerctl metadata --format '"Spotify" "{{title}}\n{{ album }} - {{ artist }}"')"
    echo $ARGS | xargs notify-send --urgency=low --expire-time=3000 --icon=/usr/share/icons/$ICONSET/$ICONSIZE/$ICON --app-name=spotifyd 
    playerctl play
fi
