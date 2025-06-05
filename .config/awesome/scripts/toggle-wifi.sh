#!/bin/bash

status=$(nmcli radio wifi)

if [ "$status" = "enabled" ]; then

    nmcli radio wifi off

    notify-send "Disabling WiFi..."

elif [ "$status" = "disabled" ]; then

    nmcli radio wifi on
    notify-send  "Enabling WiFi..."

else
    notify-send "Unknown WiFi status: $status"
fi

