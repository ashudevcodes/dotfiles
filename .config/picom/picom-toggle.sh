#!/usr/bin/env bash
set -u

AC_CONFIG="${HOME}/.config/picom/picom.conf"
DC_CONFIG="${HOME}/.config/picom/picom-battery.conf"
PICOM_BIN="picom" 

if ! command -v acpi >/dev/null 2>&1; then
  echo "acpi not found" >&2
  exit 1
fi

if pgrep -x picom >/dev/null 2>&1; then
  pkill -x picom
  sleep 0.2
fi

is_on_ac=false

if acpi -V | grep -qi "on-line"; then
  is_on_ac=true
fi

if [ "$is_on_ac" == "true" ]; then
  cfg="$AC_CONFIG"
else
  cfg="$DC_CONFIG"
fi

if [ -f "$cfg" ]; then
  exec "$PICOM_BIN" --config "$cfg" >/dev/null 2>&1 &
else
  echo "Config not found: $cfg" >&2
  exit 2
fi
