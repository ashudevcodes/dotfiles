#!/bin/bash

# Find an available display number
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
CONFIG_FILE="${1:-$HOME/.config/awesome/devTest/rc.lua}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREENSHOT_DIR="$SCRIPT_DIR/../screenshots"

# Create screenshots directory
mkdir -p "$SCREENSHOT_DIR"

# Check if Xephyr is installed
if ! command -v Xephyr &> /dev/null; then
    echo "Error: Xephyr not found. Install it with: sudo pacman -S xorg-server-xephyr"
    exit 1
fi

# Check if flameshot is installed for screenshots
if ! command -v flameshot &> /dev/null; then
    echo "Warning: flameshot not found. Install with: sudo pacman -S flameshot"
    echo "Screenshots will be disabled."
fi

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

echo "Starting Xephyr on DISPLAY=:$DISPLAY_NUM..."
Xephyr :$DISPLAY_NUM -ac -br -noreset -screen 1920x1080 &
XEPHYR_PID=$!

# Wait for Xephyr to be ready
sleep 1

# Check if Xephyr started successfully
if ! kill -0 $XEPHYR_PID 2>/dev/null; then
    echo "Error: Xephyr failed to start"
    exit 1
fi

# Screenshot function
take_screenshot() {
    local filename="$SCREENSHOT_DIR/awesome_$(date +%Y-%m-%d_%H-%M-%S).png"
    if command -v flameshot &> /dev/null; then
        DISPLAY=:$DISPLAY_NUM flameshot full -p "$filename" 2>/dev/null
        echo "Screenshot saved: $filename"
    fi
}

start_awesome() {
    echo "Starting AwesomeWM..."
    echo "Logs will appear below. Press R to restart, Q to quit, S for screenshot."
    echo "Screenshots saved to: $SCREENSHOT_DIR"
    echo "========================================="
    DISPLAY=:$DISPLAY_NUM awesome -c "$CONFIG_FILE" 2>&1 &
    AWESOME_PID=$!
    
    sleep 2
    take_screenshot
}

cleanup() {
    echo -e "\nShutting down..."
    take_screenshot
    kill $AWESOME_PID 2>/dev/null
    wait $AWESOME_PID 2>/dev/null
    kill $XEPHYR_PID 2>/dev/null
    wait $XEPHYR_PID 2>/dev/null
    exit 0
}

restart_awesome() {
    echo -e "\nRestarting AwesomeWM..."
    take_screenshot
    if kill -0 $AWESOME_PID 2>/dev/null; then
        kill $AWESOME_PID
        wait $AWESOME_PID 2>/dev/null
    fi
    sleep 0.5
    start_awesome
}

# Start AwesomeWM for the first time
start_awesome

echo ""
echo "========================================="
echo "  Hot Reload Controls:"
echo "    [R] - Restart AwesomeWM"
echo "    [Q] - Quit (exit Xephyr)"
echo "    [S] - Take Screenshot"
echo "========================================="
echo ""

# Main loop for hot reloading
while true; do
    # Read single keypress
    read -rs -n 1 key
    
    case "$key" in
        [rR])
            restart_awesome
            ;;
        [qQ])
            cleanup
            ;;
        [sS])
            echo "Taking screenshot..."
            take_screenshot
            ;;
    esac
done
