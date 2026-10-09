#!/bin/bash

status=$(iw wlan0 link)

if echo "$status" | grep -q "Not connected."; then
	rfkill toggle $(rfkill list | grep LAN | awk -F':'  '{print $1}')
    sleep 2
    new_status=$(iw wlan0 link)

    if echo "$new_status" | grep -q "Connected to"; then
        wifi_name=$(echo "$new_status" | awk -F': ' '/SSID:/{print $2; exit}')
        notify-send -i ~/.icon/wifi_connected.png "WiFi" "Connected to $wifi_name"
    fi

elif echo "$status" | grep -q "Connected to"; then
	rfkill toggle $(rfkill list | grep LAN | awk -F':'  '{print $1}')
    notify-send -i ~/.icon/wifi_disconnected.png "WiFi" "WiFi Down"

else
    notify-send "Unknown WiFi status: $status"
fi
