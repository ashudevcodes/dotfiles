#!/usr/bin/env bash

HOUR=$(date +%H)

if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 18 ]; then
  IMG="$HOME/assets/wallhaven-yqqwvd.jpg"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 20 ]; then
  IMG="$HOME/assets/future_place.png"
else
  IMG="$HOME/assets/portal_robot.png"
fi

FILE='/run/user/1000/wayland-1-awww-daemon.sock'
# Wait until daemon is actually ready
until [ -S "$FILE" ]; do
  echo "waiting.."
  sleep 1
done

awww img --transition-fps 60 --transition-type random "$IMG" || exit 1
