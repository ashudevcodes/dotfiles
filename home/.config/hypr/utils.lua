ROFI_SEARCH = "rofi -show drun"

MAIN_MOD      = "SUPER"
TERMINAL      = "kitty --single-instance"
FILE_MANAGER  = "pcmanfm"

WAYBAR_CONFIG = "-c ~/.config/waybar/bottomBar.jsonc -s ~/.config/waybar/bottom_bar.css"

take_Screen_Short = function()
  hl.dispatch(hl.dsp.exec_cmd('grim ~/Pictures/ScreenShorts/$(date +%Y-%m-%d_%H-%M-%S).png'))
  hl.dispatch(hl.dsp.exec_cmd('grim - | wl-copy'))
  hl.dispatch(hl.dsp.exec_cmd(notify_Send("Screenshot taken", "Stored in ~/Pictures/ScreenShorts/", "webcamoid", "low")))
end

toggle_window_floating = function ()

  local m = hl.get_active_monitor()
  local width, height

  if (m) then
    width = math.floor(m.width * 0.6)
    height = math.floor(m.height * 0.6)
  end

  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.resize({ x = width, y = height }))
  hl.dispatch(hl.dsp.window.center())
end

local tp_on = true
function disable_touch_pad()
  tp_on = not tp_on
  if tp_on then
    hl.exec_cmd(notify_Send("Touchpad status", "Enabled", "computer", "low"))
  else
    hl.exec_cmd(notify_Send("Touchpad status", "Disable", "computer", "low"))
  end

  hl.dispatch(hl.dsp.exec_cmd("~/.local/bin/touchpad-toggle.sh"))
end

function notify_Send(summary, body, icon, urgency)
  return string.format([[notify-send -e -u "%s" -t 5500 -a "Hyprland" -i "%s" "%s" "%s"]], urgency, icon, summary, body)
end
