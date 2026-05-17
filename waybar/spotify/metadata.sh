#!/bin/bash

TITLE=$(playerctl -p spotify metadata xesam:title 2>/dev/null)
ARTIST=$(playerctl -p spotify metadata xesam:artist 2>/dev/null)

if [ -n "$TITLE" ] && [ -n "$ARTIST" ]; then
    echo "$TITLE - $ARTIST"
else
    exit 1
fi
