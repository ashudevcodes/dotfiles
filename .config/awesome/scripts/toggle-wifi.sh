#!/bin/bash

status=$(iw wlan0 link)

if echo "$status" | grep -q "Not connected."; then
	rfkill toggle $(rfkill list | grep LAN | awk -F':'  '{print $1}')
    sleep 2
    new_status=$(iw wlan0 link)

    if echo "$new_status" | grep -q "Connected to"; then
        wifi_name=$(echo "$new_status" | awk -F': ' '/SSID:/{print $2; exit}')
        notify-send "WiFi" "Connected to $wifi_name"
    else
        notify-send "Failed to connect to Home."
    fi

elif echo "$status" | grep -q "Connected to"; then
	rfkill toggle $(rfkill list | grep LAN | awk -F':'  '{print $1}')
    notify-send "WiFi Down"

else
    notify-send "Unknown WiFi status: $status"
fi
