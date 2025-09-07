#!/usr/bin/env bash
set -u

AC_CONFIG="${HOME}/.config/picom/picom.conf"
DC_CONFIG="${HOME}/.config/picom/picom-battery.conf"
PICOM_BIN="picom" 

if ! command -v upower >/dev/null 2>&1; then
  echo "upower not found" >&2
  exit 1
fi

if pgrep -x picom >/dev/null 2>&1; then
  pkill -x picom
  sleep 0.2
fi

is_on_ac=false

while IFS= read -r dev; do
  [ -z "$dev" ] && continue
  if upower -i "$dev" 2>/dev/null | grep -qi "line-power"; then
    if upower -i "$dev" 2>/dev/null | grep -qi "online:\s*yes"; then
      is_on_ac=true
      break
    fi
  fi
done < <(upower -e 2>/dev/null)

if [ "$is_on_ac" = false ]; then
  while IFS= read -r dev; do
    [ -z "$dev" ] && continue
    if upower -i "$dev" 2>/dev/null | grep -qi "battery"; then
      if upower -i "$dev" 2>/dev/null | grep -qi "state:\s*charging"; then
        is_on_ac=true
        break
      fi
    fi
  done < <(upower -e 2>/dev/null)
fi

if [ "$is_on_ac" = true ]; then
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
