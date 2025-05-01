 #!/bin/bash

# Path to the Hyprland configuration directory

CONFIG_DIR="$HOME/.config/hypr"

# Name of the touchpad configuration file

TOUCHPAD_CONFIG="touchpad.conf"

# Full path to the touchpad configuration file

CONFIG_FILE="$CONFIG_DIR/$TOUCHPAD_CONFIG"

# Check if the touchpad is currently enabled or disabled

enabled=$(grep -o "enabled\s*=\s*[01]" "$CONFIG_FILE")

# Toggle the touchpad state

if [ "$enabled" == "enabled = 0" ]; then

sed -i "s/enabled\s*=\s*0/enabled = 1/" "$CONFIG_FILE"

state="enabled"

else

sed -i "s/enabled\s*=\s*1/enabled = 0/" "$CONFIG_FILE"

state="disabled"

fi

# Reload the settings in Hyprland

# Replace the command below with the actual command to reload settings in Hyprland

# hyprctl reload-settings

# Display notification based on touchpad state

if [ "$state" == "enabled" ]; then

notify-send -u low "Touchpad Enabled" 

else

notify-send -u low "Touchpad Disabled" 

fi

echo "Touchpad state toggled." 
