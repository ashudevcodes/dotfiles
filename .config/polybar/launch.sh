#!/usr/bin/env bash

if pgrep -x polybar >/dev/null; then
    polybar-msg cmd quit
else
    polybar  2>&1 | tee -a /tmp/polybar1.log & disown
fi
