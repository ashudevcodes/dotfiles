#!/usr/bin/env bash

CONFIG="$HOME/.config/niri/cfg/input.kdl"

STATE_FILE=/tmp/touchpadState

if grep -q disabled "$STATE_FILE" 2>/dev/null; then
  sed -Ei '/touchpad[[:space:]]*\{/,/\}/ s#^[[:space:]]*off#\t//off#' "$CONFIG"
  echo enabled > "$STATE_FILE"
else
  sed -Ei '/touchpad[[:space:]]*\{/,/\}/ s#^[[:space:]]*//[[:space:]]*off#\toff#' "$CONFIG"
  echo disabled > "$STATE_FILE"
fi

niri msg action load-config-file

pkill -RTMIN+8 waybar
