local main_mod      = "SUPER"
local terminal      = "footclient"
local menu          = "rofi -show drun"
local filemanager   = "dolphin"

local waybar_config = "-c ~/.config/waybar/config-vertical.jsonc -s ~/.config/waybar/style-vertical.css"

hl.bind(main_mod .. "+ SHIFT + W", hl.dsp.exec_cmd("pkill -x waybar || waybar " .. waybar_config))
hl.bind(main_mod .. " + v", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + Space", hl.dsp.exec_cmd(menu))

hl.bind(main_mod .. " + Q", hl.dsp.window.close())

hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(filemanager))

hl.bind("ALT" .. "+ SHIFT + P", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.exit()' ; systemctl poweroff"))
hl.bind("ALT" .. "+ SHIFT + L", hl.dsp.exec_cmd("hyprlock -q"))

hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(main_mod .. "+ SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(main_mod .. "+ SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(main_mod .. "+ SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(main_mod .. "+ SHIFT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(main_mod .. "+ SHIFT + R", hl.dsp.layout("colresize +conf"))
hl.bind(main_mod .. "+ SHIFT + F", hl.dsp.layout("fit active"))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

local lock_and_repeat = { locked = true, repeating = true }

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+; volume-notify"),
	lock_and_repeat)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; volume-notify"),
	lock_and_repeat)

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle;volume-notify"), lock_and_repeat)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; volume-notify"),
	lock_and_repeat)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+; brightness-notify"), lock_and_repeat)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-; brightness-notify"), lock_and_repeat)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, action = "float" })
