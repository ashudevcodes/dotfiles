#!/usr/bin/env bash
set -x
HOUR=$(date +%H)

if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 18 ]; then
  IMG="$HOME/dotfiles/assets/wallhaven-yqqwvd.jpg"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 22 ]; then
  IMG="$HOME/dotfiles/assets/the_wild_robot.jpg"
else
  IMG="$HOME/dotfiles/assets/space-gray.jpg"
fi

if [ "$#" -gt 0 ]; then
    IMG="$*"
fi

wallust run -q "$IMG"

FILE_1='/run/user/1000/wayland-1-awww-daemon.sock'
FILE_0='/run/user/1000/wayland-0-awww-daemon.sock'

# Wait until either daemon socket is actually ready
until [[ -S "$FILE_1" || -S "$FILE_0" ]]; do
    echo "waiting.."
    sleep 1
done


awww img --transition-fps 60 --transition-type random "$IMG" || exit 1
