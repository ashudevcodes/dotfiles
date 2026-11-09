hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp -b "#00000000" -c "#70707099")" - | wl-copy'))
hl.gesture({ fingers = 4, direction = "down", action = take_Screen_Short })

hl.bind("SHIFT" .. "+ PRINT",
hl.dsp.exec_cmd('grim ~/Pictures/ScreenShorts/$(date +%Y-%m-%d_%H-%M-%S).png; notify-send "Screen Short Taken"'))
hl.bind(MAIN_MOD .. "+ SHIFT + W", hl.dsp.exec_cmd("pkill -x waybar || waybar " .. WAYBAR_CONFIG))

hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp -b "#00000000" -c "#70707099")" - | wl-copy'))

hl.bind("SHIFT" .. "+ PRINT",
	hl.dsp.exec_cmd('grim ~/Pictures/ScreenShorts/$(date +%Y-%m-%d_%H-%M-%S).png; notify-send "Screen Short Taken"'))

hl.bind(MAIN_MOD .. "+ SHIFT + W", hl.dsp.exec_cmd("pkill -x waybar || waybar " .. WAYBAR_CONFIG))

hl.bind(MAIN_MOD .. " + v", toggle_window_floating)

hl.bind(MAIN_MOD .. " + Q", hl.dsp.window.close())
hl.bind(MAIN_MOD .. " + F", hl.dsp.window.fullscreen({action = "toggle"}))

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

hl.bind(MAIN_MOD .. "+ Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next({ floating = true, next = false }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

hl.bind(MAIN_MOD .. "+ SHIFT + R", hl.dsp.layout("colresize +conf"))
hl.bind(MAIN_MOD .. "+ SHIFT + F", hl.dsp.layout("fit active"))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(MAIN_MOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(MAIN_MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

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
hl.gesture({ fingers = 3, direction = "down", action = "close" })

hl.bind("F1", disable_touch_pad)

hl.bind(MAIN_MOD .. "+ Space", hl.dsp.exec_cmd(ROFI_SEARCH))

hl.bind(MAIN_MOD .."+ M", function() hl.plugin.hyprgenie.minimize() end)
hl.bind(MAIN_MOD .."+ SHIFT + M",  function() hl.plugin.hyprgenie.restore()  end)
hl.bind(MAIN_MOD .."+ s", hl.dsp.workspace.toggle_special("minimized"))

hl.bind(MAIN_MOD .."+ Escape", hl.dsp.exit())

require("layouts.floating_layout")

local cascade = _G.Cascade

local layouts = { "cascade", "dwindle", "scrolling" }

local function enable_cascade(workspace)
    cascade.enabled[workspace.id] = true
    cascade.fit(workspace.id)
end

-- first workspace i wnat be floating
--[[ if hl.get_active_workspace().id == 1 then
  enable_cascade(hl.get_active_workspace())
end ]]

local function disable_cascade(workspace)
    local id = workspace.id

    cascade.enabled[id] = nil
    cascade.queue[id] = nil

    for _, window in ipairs(hl.get_workspace_windows(id)) do
	pcall(function()
	    hl.dispatch(hl.dsp.window.float({
		window = window,
		action = "disable",
	    }))
	end)
    end
end

local function get_current_layout(workspace)
    if cascade.enabled[workspace.id] then
	return "cascade"
    end

    return workspace.tiled_layout
end

local function get_next_layout(current)
    for i, layout in ipairs(layouts) do
	if layout == current then
	    return layouts[(i % #layouts) + 1]
	end
    end

    return layouts[1]
end

local function switch_layout(workspace, layout)
    if layout == "cascade" then
	enable_cascade(workspace)
	return
    end

    disable_cascade(workspace)

    hl.workspace_rule({
	workspace = tostring(workspace.name),
	layout = layout,
    })
end


hl.bind(MAIN_MOD .. " + w", function()
    local workspace = hl.get_active_special_workspace()
	or hl.get_active_workspace()

    if not workspace then return end

    local current = get_current_layout(workspace)
    local next = get_next_layout(current)

    switch_layout(workspace, next)

    hl.dispatch(hl.dsp.exec_cmd(
	notify_Send("Layout switch to ", next, "mate-session-properties", "low")
    ))
end)

hl.bind(MAIN_MOD .. "+ SHIFT + G", function()
  local game_mode = (hl.get_config("decoration.blur.enabled") == false)

  if game_mode then
    hl.exec_cmd("hyprctl reload")
    return
  end

  hl.monitor({
    output = "eDP-1",
    mode = "1536x864@60",
    scale = 1,
  })

  hl.config({
    decoration = {
      blur = { enabled = false },
    }
  })
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
