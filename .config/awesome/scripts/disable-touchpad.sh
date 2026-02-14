#!/bin/bash

declare -i ID
ID=$(xinput list | grep -Eio '(touchpad|glidepoint)\s*id=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}')

if [ -z "$ID" ]; then
    echo "No touchpad device found"
    exit 1
fi

declare -i STATE
STATE=$(xinput list-props "$ID" | grep 'Device Enabled' | awk '{print $4}')
if [ "$STATE" -eq 1 ]
then
    xinput disable "$ID"
    echo "Touchpad disabled."
	echo "disabled" > /tmp/touchpadState
    notify-send  'Touchpad' 'Touchpad Disabled' 
else
    xinput enable "$ID"
    echo "Touchpad enabled."
    notify-send 'Touchpad' 'Touchpad Enabled' 
	echo "enabled" > /tmp/touchpadState
fi
