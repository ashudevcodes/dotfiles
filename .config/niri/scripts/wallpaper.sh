#!/usr/bin/env bash

# Start daemon if not running
pgrep -x awww-daemon >/dev/null || \
  nohup awww-daemon --no-cache > /dev/null 2>&1 &

# Wait until daemon is actually ready
until pgrep -x awww-daemon >/dev/null; do
  echo "waiting.."
  sleep 1
done

HOUR=$(date +%H)

if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 20 ]; then
  IMG="$HOME/assets/wallhaven-yqqwvd.jpg"
else
  IMG="$HOME/assets/portal_robot.png"
fi

awww img --transition-fps 60 --transition-type random "$IMG"
