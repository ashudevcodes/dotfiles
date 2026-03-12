#!/bin/bash

find_display() {
    for i in {3..99}; do
        if ! test -S "/tmp/.X11-unix/X$i"; then
            echo $i
            return
        fi
    done
    echo "3"
}

DISPLAY_NUM=$(find_display)
CONFIG_FILE="${1:-$HOME/.config/awesome/rc.lua}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v Xephyr &> /dev/null; then
    echo "Error: Xephyr not found. Install it with: sudo pacman -S xorg-server-xephyr"
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

echo "Starting Xephyr on DISPLAY=:$DISPLAY_NUM..."
Xephyr :$DISPLAY_NUM -ac -br -noreset -screen 1280x720  &
XEPHYR_PID=$!

# Wait for Xephyr to be ready
sleep 1

if ! kill -0 $XEPHYR_PID 2>/dev/null; then
    echo "Error: Xephyr failed to start"
    exit 1
fi

start_awesome() {
    echo "Starting AwesomeWM..."
    echo "Logs will appear below. Press R to restart, Q to quit."
    echo "========================================="
    DISPLAY=:$DISPLAY_NUM awesome -c "$CONFIG_FILE" 2>&1 &
    AWESOME_PID=$!
}

cleanup() {
    echo -e "\nShutting down..."
    kill $AWESOME_PID 2>/dev/null
    wait $AWESOME_PID 2>/dev/null
    kill $XEPHYR_PID 2>/dev/null
    wait $XEPHYR_PID 2>/dev/null
    exit 0
}

restart_awesome() {
    echo -e "\nRestarting AwesomeWM..."
    if kill -0 $AWESOME_PID 2>/dev/null; then
        kill $AWESOME_PID
        wait $AWESOME_PID 2>/dev/null
    fi
    sleep 0.5
    start_awesome
}

start_awesome

echo ""
echo "========================================="
echo "  Hot Reload Controls:"
echo "    [R] - Restart AwesomeWM"
echo "    [Q] - Quit (exit Xephyr)"
echo "========================================="
echo ""

while true; do
    read -rs -n 1 key
    
    case "$key" in
        [rR])
            restart_awesome
            ;;
        [qQ])
            cleanup
            ;;
    esac
done
