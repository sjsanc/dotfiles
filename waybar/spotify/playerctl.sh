#!/bin/bash

case "$1" in
    next)       playerctl -p spotify next ;;
    previous)   playerctl -p spotify previous ;;
    play-pause) playerctl -p spotify play-pause ;;
esac

sleep 0.15
pkill -SIGRTMIN+10 waybar
