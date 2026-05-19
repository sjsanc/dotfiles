#!/bin/bash

STATUS=$(playerctl -p spotify status 2>/dev/null)

case "$STATUS" in
    "Paused")  printf '\U000F03E4\n' ;;  # nf-md-pause
    "Playing") printf '\U000F040A\n' ;;  # nf-md-play
    *)         printf '\U000F075A\n' ;;  # nf-md-music_off
esac
