#!/bin/sh

step=5
max=100

function get_current_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | awk -F '/' '{print $2}' | grep -o '[0-9]\+'
}

if [ $1 == "raise" ]; then

  if [ `get_current_volume` -lt ${max} ]; then
    pactl set-sink-volume @DEFAULT_SINK@ "+${step}%"
  fi

elif [ $1 == "lower" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ "-${step}%"
elif [ $1 == "toggle_mute" ]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
else
  echo "Unrecognized parameter: ${1}"
  echo "Usage should be: volume.sh <raise|lower|toggle_mute>"
fi

