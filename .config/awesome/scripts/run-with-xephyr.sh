#!/bin/bash

Xephyr :3 -ac -br -noreset -screen 1280x720 &
sleep 0.5

DISPLAY=:3 awesome -c ~/.config/awesome/awesomedev/rc.lua.new
XEPHYR_PID=$!
kill ${XEPHYR_PID}
