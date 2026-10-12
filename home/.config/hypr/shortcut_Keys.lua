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
hl.bind(MAIN_MOD .. "+ SHIFT + W", hl.dsp.exec_cmd("pkill -x waybar || waybar " .. WAYBAR_CONFIG))
hl.bind(MAIN_MOD .. " + v", hl.dsp.window.float({ action = "toggle" }))

hl.bind(MAIN_MOD .. " + Q", hl.dsp.window.close())

hl.bind(MAIN_MOD .. " + RETURN", hl.dsp.exec_cmd(TERMINAL))
hl.bind(MAIN_MOD .. " + SHIFT + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(MAIN_MOD .. " + E", hl.dsp.exec_cmd(FILE_MANAGER))

hl.bind("ALT" .. "+ SHIFT + P", hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind("ALT" .. "+ SHIFT + L", hl.dsp.exec_cmd("hyprlock -q"))

hl.bind(MAIN_MOD .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(MAIN_MOD .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(MAIN_MOD .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(MAIN_MOD .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(MAIN_MOD .. "+ SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(MAIN_MOD .. "+ SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(MAIN_MOD .. "+ SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(MAIN_MOD .. "+ SHIFT + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(MAIN_MOD .. "+ SHIFT + R", hl.dsp.layout("colresize +conf"))
hl.bind(MAIN_MOD .. "+ SHIFT + F", hl.dsp.layout("fit active"))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(MAIN_MOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(MAIN_MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(MAIN_MOD .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(MAIN_MOD .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(MAIN_MOD .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(MAIN_MOD .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MAIN_MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MAIN_MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- resize windows using keyboard
hl.bind(MAIN_MOD .. "+ LEFT", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. "+ RIGHT", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. "+ UP", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. "+ DOWN", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

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

hl.bind(MAIN_MOD .. " + w", function()
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

hl.bind(MAIN_MOD .. "+ SHIFT + G", function()
	local game_mode = (hl.get_config("decoration.blur.enabled") == false)
	USE_ROFI = true

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


local function app_Search()
	hl.dispatch(hl.dsp.exec_cmd(MARIA_TOGGLE))

	if USE_ROFI then
		USE_ROFI = false
	else
		USE_ROFI = true
	end
end

local tp_on = true


local function disable_touch_pad()
	tp_on = not tp_on
	if tp_on then
		hl.exec_cmd(notify_Send("Touchpad status", "Enabled", "computer", "low"))
	else
		hl.exec_cmd(notify_Send("Touchpad status", "Disable", "computer", "low"))
	end

	hl.device({ name = "elan0718:00-04f3:30fd-touchpad", enabled = tp_on })
	hl.dispatch(hl.dsp.exec_cmd("pkexec toggle-touchpad"))
end

hl.bind(MAIN_MOD .. "+ SHIFT+M", app_Search)
hl.bind(MAIN_MOD .. "+ F1", disable_touch_pad)

hl.bind(MAIN_MOD .. "+ Space", function()
	if USE_ROFI then
		hl.dispatch(hl.dsp.exec_cmd(ROFI_SEARCH))
	else
		hl.dispatch(hl.dsp.exec_cmd(MARIA_SEARCH .. ' "emit search"'))
	end
end)

hl.bind(MAIN_MOD .. "+ P", function()
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

hl.on("window.urgent", function(win)
	if not win then
		return
	end

	local workspace = win.workspace
	local active_workspace = hl.get_active_workspace()
	if workspace and active_workspace and workspace.id ~= active_workspace.id then
		hl.dispatch(hl.dsp.exec_cmd(notify_Send("Urgent: workspace " .. workspace.id .. "", win.title, "computer", "low")))
	end
end)
