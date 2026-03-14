#!/bin/bash

playerctl -p spotify status &>/dev/null || exit 0

album_art=$(playerctl -p spotify metadata mpris:artUrl 2>/dev/null)
if [[ -z $album_art ]]; then
    exit 0
fi
curl -s --max-time 3 "${album_art}" --output "/tmp/cover.jpeg"
echo "/tmp/cover.jpeg"
