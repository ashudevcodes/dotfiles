#!/bin/sh
HOUR=$(date +%H)
if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 20 ]; then
    IMG=~/assets/wallhaven-yqqwvd.jpg
else
    IMG=~/assets/portal_robot.png
fi

awww img "$IMG"
