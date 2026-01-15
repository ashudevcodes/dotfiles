#!/bin/bash

Xephyr :3 -ac -br -noreset -screen 1920x1080 &
sleep 0.5

DISPLAY=:3 awesome -c ~/.config/awesome/rc.lua
XEPHYR_PID=$!
kill ${XEPHYR_PID}
