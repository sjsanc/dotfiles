#!/bin/bash

STATUS=$(playerctl -p spotify status)

if [ "$STATUS" == "Stopped" ]; then
    echo ""  # Stopped icon
elif [ "$STATUS" == "Paused" ]; then
    echo ""  # Paused icon
elif [ "$STATUS" == "Playing" ]; then
    echo ""  # Playing icon
else
    echo ''
fi