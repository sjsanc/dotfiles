if [[ $1 == "next" ]]; then
    playerctl -p spotify next; pkill -SIGRTMIN+10 waybar
fi

if [[ $1 == "previous" ]]; then
    playerctl -p spotify previous; pkill -SIGRTMIN+10 waybar
fi

if [[ $1 == "play-pause" ]]; then
    playerctl -p spotify play-pause; pkill -SIGRTMIN+10 waybar
fi