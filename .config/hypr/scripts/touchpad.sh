 #!/bin/bash

CONFIG_DIR="$HOME/.config/hypr"

TOUCHPAD_CONFIG="touchpad.conf"

CONFIG_FILE="$CONFIG_DIR/$TOUCHPAD_CONFIG"

# Check if the touchpad is currently enabled or disabled

enabled=$(grep -o "enabled\s*=\s*[01]" "$CONFIG_FILE")

# Toggle the touchpad state

if [ "$enabled" == "enabled = 0" ]; then

sed -i "s/enabled\s*=\s*0/enabled = 1/" "$CONFIG_FILE"

notify-send -i input-mouse -u low "Touchpad  " "Enabled" 

else

sed -i "s/enabled\s*=\s*1/enabled = 0/" "$CONFIG_FILE"

notify-send -i input-mouse -u low "Touchpad 󰍾 " "Disabled"

fi
