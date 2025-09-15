#!/bin/bash

TOUCHPAD_ID=$(xinput list | grep -i 'touchpad' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')

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
  notify-send -i ~/.icon/trackpad_disable.png "TrackPad" "Trackpad disable!"
}

enable_touchpad(){
  xinput enable $TOUCHPAD_ID
  notify-send -i ~/.icon/trackpad_enable.png "TrackPad" "Trackpad enable!"
}
get_touchpad_state
trackpad_state=$?

if [ $trackpad_state -eq 1 ]; then
	disable_touchpad
else
	enable_touchpad
fi

