#!/bin/bash

get_status_icon() {
  status=$(playerctl -p spotify status)

  if [ "$status" == "Stopped" ]; then
    echo ""  # Stopped icon
  elif [ "$status" == "Paused" ]; then
    echo ""  # Paused icon
  elif [ "$status" == "Playing" ]; then
    echo ""  # Playing icon
  else
    echo ''
  fi
}

get_metadata() {
  track=$(playerctl -p spotify metadata --format "{{xesam:title}}" 2>/dev/null || echo "Unknown")
  artist=$(playerctl -p spotify metadata --format "{{xesam:artist}}" 2>/dev/null || echo "Unknown")

  if [ ${#track} -gt 25 ]; then
    track="${track:0:15}..."
  fi

  if [ ${#artist} -gt 25 ]; then
    artist="${artist:0:15}..."
  fi

  if [ "$track" != "Unknown" ] && [ "$artist" != "Unknown" ]; then
    echo "$track - $artist"
  else
    echo ""
  fi
}

if [ "$1" == "--status" ]; then
  get_status_icon
elif [ "$1" == "--metadata" ]; then
  get_metadata
else
  echo 'ERROR'
  exit 1
fi
