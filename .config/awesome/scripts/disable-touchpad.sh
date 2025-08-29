#!/bin/bash

TOUCHPAD_ID=10

get_touchpad_state(){
  state=$(xinput list-props $TOUCHPAD_ID | grep "Device Enabled" | awk '{print $4}')
	  if [ "$state" -eq 1 ]; then
		return 1
	  else
		return 0
	  fi
}

disable_touchpad(){
  xinput disable $TOUCHPAD_ID
  notify-send "Touch Pad" "touch pad disable!"
}

enable_touchpad(){
  xinput enable $TOUCHPAD_ID
  notify-send "touch pad" "touch pad enable!"
}
get_touchpad_state
trackpad_state=$?

if [ $trackpad_state -eq 1 ]; then
	disable_touchpad
else
	enable_touchpad
fi

