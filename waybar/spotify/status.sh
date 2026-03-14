#!/bin/bash

playerctl -p spotify status &>/dev/null || exit 0

STATUS=$(playerctl -p spotify status 2>/dev/null)

if [ "$STATUS" == "Paused" ]; then
    echo ""
elif [ "$STATUS" == "Playing" ]; then
    echo ""
else
    echo ""
fi
