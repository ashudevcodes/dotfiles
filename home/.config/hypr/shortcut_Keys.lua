local main_mod      = "SUPER"
-- local terminal      = "foot"
local terminal      = "kitty --single-instance"
local filemanager   = "pcmanfm"

local waybar_config = "-c ~/.config/waybar/bottomBar.jsonc -s ~/.config/waybar/bottom_bar.css"

local function notify_Send(summary, body, icon, urgency)
	return string.format(
		[[notify-send -e -u "%s" -t 5500 -a "Hyprland" -i "%s" "%s" "%s"]],
		urgency, icon, summary, body)
end

local take_Screen_Short = function()
	hl.dispatch(hl.dsp.exec_cmd('grim ~/Pictures/ScreenShorts/$(date +%Y-%m-%d_%H-%M-%S).png'))
	hl.dispatch(hl.dsp.exec_cmd('grim - | wl-copy'))
	hl.dispatch(hl.dsp.exec_cmd(notify_Send("Screenshot taken", "Stored in ~/Pictures/ScreenShorts/", "webcamoid", "low")))
end

hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp -b "#00000000" -c "#70707099")" - | wl-copy'))
hl.gesture({ fingers = 4, direction = "down", action = take_Screen_Short })

hl.bind("SHIFT" .. "+ PRINT",
	hl.dsp.exec_cmd('grim ~/Pictures/ScreenShorts/$(date +%Y-%m-%d_%H-%M-%S).png; notify-send "Screen Short Taken"'))
hl.bind(main_mod .. "+ SHIFT + W", hl.dsp.exec_cmd("pkill -x waybar || waybar " .. waybar_config))
hl.bind(main_mod .. " + v", hl.dsp.window.float({ action = "toggle" }))

hl.bind(main_mod .. " + Q", hl.dsp.window.close())

hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(filemanager))

hl.bind("ALT" .. "+ SHIFT + P", hl.dsp.exec_cmd("systemctl poweroff"))
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
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- resize windows using keyboard
hl.bind(main_mod .. "+ LEFT", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(main_mod .. "+ RIGHT", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(main_mod .. "+ UP", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(main_mod .. "+ DOWN", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

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

hl.bind(main_mod .. " + w", function()
	local ws = hl.get_active_workspace()
	if ws == nil then
		hl.notification.create({
			text = "no active workspace",
			timeout = 1000,
			duration = 1000
		})

		return
	end

	local current = ws.tiled_layout

	local next_layout = (current == "scrolling") and "dwindle" or "scrolling"

	hl.workspace_rule({
		workspace = tostring(ws.id),
		layout = next_layout,
	})

	hl.dispatch(hl.dsp.exec_cmd(notify_Send("Layout swithch to ", next_layout, "mate-session-properties", "low")))
end)

hl.bind("SUPER + G", function()
	local game_mode = (hl.get_config("decoration.blur.enabled") == false)
	use_rofi = true

	if game_mode then
		hl.exec_cmd("hyprctl reload")
		return
	end
	hl.monitor({
		output = "eDP-1",
		mode = "1536x864",
		scale = 1,
	})
	hl.config({


		decoration = {
			shadow = { enabled = false },
			blur = { enabled = false },
		}
	})
end)

local rofi_search = "rofi -show drun"
local use_rofi = true
local maria_search = "pleamar --say marea"
local maria_toggle = 'pkill -x pleamar || pleamar --scene  ~/.local/opt/marea/marea.plm --no-hud'

local function app_Search()
	hl.dispatch(hl.dsp.exec_cmd(maria_toggle))

	if use_rofi then
		use_rofi = false
	else
		use_rofi = true
	end
end

local tp_on = true


local function disable_touch_pad()
	tp_on = not tp_on
	if tp_on then
		hl.exec_cmd(notify_Send("Touchpad Status", "touchpad is enabled", "computer", "low"))
	else
		hl.exec_cmd(notify_Send("Touchpad Status", "touchpad is disable", "computer", "low"))
	end

	hl.device({ name = "elan0718:00-04f3:30fd-touchpad", enabled = tp_on })
	hl.dispatch(hl.dsp.exec_cmd("pkexec toggle-touchpad"))
end

hl.bind(main_mod .. "+ SHIFT+M", app_Search)
hl.bind(main_mod .. "+ F1", disable_touch_pad)

hl.bind(main_mod .. "+ Space", function()
	if use_rofi then
		hl.dispatch(hl.dsp.exec_cmd(rofi_search))
	else
		hl.dispatch(hl.dsp.exec_cmd(maria_search .. ' "emit search"'))
	end
end)

hl.bind(main_mod .. "+ P", function()
	local m = hl.get_active_monitor()
	local width, height

	if (m) then
		width = math.floor(m.width * 0.6)
		height = math.floor(m.height * 0.6)
	end

	hl.dispatch(hl.dsp.window.float())
	hl.dispatch(hl.dsp.window.resize({ x = width, y = height }))
	hl.dispatch(hl.dsp.window.center())
	hl.dispatch(hl.dsp.window.pin())
end)
