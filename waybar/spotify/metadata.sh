#!/bin/bash

METADATA=$(playerctl -p spotify metadata)

ARTIST=$(echo "$METADATA" | grep title | awk '{ print $3 }')
TITLE=$(echo "$METADATA" | grep artist | awk '{ print $3 }')

# Clamp function to limit string length
clamp() {
    local text=$1
    local max_length=$2
    if [ "${#text}" -gt "$max_length" ]; then
        echo "${text:0:max_length}..."
    else
        echo "$text"
    fi
}

if [ "$TITLE" != "Unknown" ] && [ "$ARTIST" != "Unknown" ]; then
    echo "$(clamp "$TITLE" 25) - $(clamp "$ARTIST" 25)"
else
    echo ""
fi
