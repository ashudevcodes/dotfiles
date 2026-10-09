#!/bin/bash
#pactl subscribe 2>/dev/null | while read -r line; do
#if [[ $line == *"sink"* ]]; then

STATE=$(pactl get-sink-mute @DEFAULT_SINK@)
if [[ $STATE == *"yes"* ]]; then
  pkexec /usr/local/bin/set-mute-led 1
else
  pkexec /usr/local/bin/set-mute-led 0
fi

#fi
#done
