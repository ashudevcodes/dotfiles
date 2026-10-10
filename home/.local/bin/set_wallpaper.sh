#!/usr/bin/env bash

HOUR=$(date +%H)

if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 18 ]; then
  IMG="$HOME/dotfiles/assets/wallhaven-yqqwvd.jpg"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 22 ]; then
  IMG="$HOME/dotfiles/assets/the_wild_robot.jpg"
else
  IMG="$HOME/dotfiles/assets/Johan_Christian_Dahl_Dresden_by_Moonlight.jpg"
fi

wallust run -q "$IMG"

FILE='/run/user/1000/wayland-1-awww-daemon.sock'
# Wait until daemon is actually ready
until [ -S "$FILE" ]; do
  echo "waiting.."
  sleep 1
done


awww img --transition-fps 60 --transition-type random "$IMG" || exit 1
