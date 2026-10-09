#!/usr/bin/env bash

CONFIG="$HOME/.config/niri/cfg/input.kdl"

STATE_FILE=/tmp/touchpadState

if grep -q disabled "$STATE_FILE" 2>/dev/null; then
  sed -Ei '/touchpad[[:space:]]*\{/,/\}/ s#^[[:space:]]*off#\t//off#' "$CONFIG"
  echo enabled > "$STATE_FILE"
  notify-send \
	-a osd \
	-h string:x-canonical-private-synchronous:touchpad \
	"󰟸 Touchpad Enabled"
else
  sed -Ei '/touchpad[[:space:]]*\{/,/\}/ s#^[[:space:]]*//[[:space:]]*off#\toff#' "$CONFIG"
  echo disabled > "$STATE_FILE"
  notify-send \
	-a osd \
	-h string:x-canonical-private-synchronous:touchpad \
	"󰤳 Touchpad Disabled"
fi

niri msg action load-config-file

pkill -RTMIN+8 waybar
