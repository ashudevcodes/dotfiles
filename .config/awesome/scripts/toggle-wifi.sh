#!/bin/bash

status=$(iw wlan0 link)

if echo "$status" | grep -q "Not connected."; then

    sudo iwctl station wlan0 connect Home

    sleep 2
    new_status=$(iw wlan0 link)

    if echo "$new_status" | grep -q "Connected to"; then
        notify-send "WiFi connected to Home!"
    else
        notify-send "Failed to connect to Home."
    fi

elif echo "$status" | grep -q "Connected to"; then
    sudo iwctl station wlan0 disconnect
    notify-send "WiFi disconnected."

else
    notify-send "Unknown WiFi status: $status"
fi
