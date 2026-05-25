#!/usr/bin/env bash

HOUR=$(date +%H)

if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 20 ]; then
  IMG="$HOME/assets/wallhaven-yqqwvd.jpg"
else
  IMG="$HOME/assets/portal_robot.png"
fi

# Wait until daemon is actually ready
until pgrep -x awww-daemon >/dev/null; do
  echo "waiting.."
  sleep 1
done

awww img --transition-fps 60 --transition-type random "$IMG"
