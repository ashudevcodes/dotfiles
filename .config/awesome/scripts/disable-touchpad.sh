#!/bin/bash

ID=$(xinput list | grep -Eio '(touchpad|glidepoint)\s*id=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}')

if [ -z "$ID" ]; then
  echo "No touchpad device found" >&2
  exit 1
fi

STATE=$(xinput list-props "$ID" | grep 'Device Enabled' | awk '{print $4}')

if [ -z "$STATE" ]; then
  echo "Could not read touchpad state" >&2
  exit 1
fi

if [ "$STATE" -eq 1 ]; then
  xinput disable "$ID"
  echo "disabled" > /tmp/touchpadState
  nohup unclutter > /dev/null 2>&1 &
  disown
else
  xinput enable "$ID"
  echo "enabled" > /tmp/touchpadState
  killall unclutter 2>/dev/null || true
fi
