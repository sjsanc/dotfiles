#!/bin/bash

playerctl -p spotify status &>/dev/null || exit 0

TITLE=$(playerctl -p spotify metadata xesam:title 2>/dev/null)
ARTIST=$(playerctl -p spotify metadata xesam:artist 2>/dev/null)

clamp() {
    local text=$1
    local max_length=$2
    if [ "${#text}" -gt "$max_length" ]; then
        echo "${text:0:$max_length}..."
    else
        echo "$text"
    fi
}

if [ -n "$TITLE" ] && [ -n "$ARTIST" ]; then
    echo "$(clamp "$TITLE" 25) - $(clamp "$ARTIST" 25)"
else
    echo ""
fi
