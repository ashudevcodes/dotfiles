local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

local HOME = os.getenv("HOME")
local path_to_icons = HOME .. "/.local/icon/fan/"
local command = HOME .. "/.local/bin/lappyFan state"

local fanWibox = wibox.widget {
	{
		id = "icon",
		image = nil,
		widget = wibox.widget.imagebox,
	},
	widget = wibox.container.margin,
	buttons = gears.table.join(
		awful.button({}, 1, function() awful.spawn(command) end)
	)
}

local function updateFanIcon()
	awful.spawn.easy_async_with_shell(command, function(out)
		local icon_path
		if out:match("running") then
			icon_path = path_to_icons .. "fan-on.svg"
			print(icon_path)
		else
			icon_path = path_to_icons .. "fan-off.svg"
			print(icon_path)
		end
		fanWibox.icon.image = gears.surface.load_uncached(icon_path)
	end)
end

updateFanIcon()
gears.timer {
	timeout = 5,
	autostart = true,
	callback = updateFanIcon
}

local notification
local function show_fan_status()
	awful.spawn.easy_async_with_shell(command, function(stdout)
		naughty.destroy(notification)
		notification = naughty.notify {
			text = stdout:gsub("\n+$", ""),
			title = "Fan Status",
			position = "top_right",
			timeout = 3,
			width = 250,
			screen = awful.screen.focused()
		}
	end)
end

fanWibox:connect_signal("mouse::enter", function()
	show_fan_status()
end)

fanWibox:connect_signal("mouse::leave", function()
	if notification then naughty.destroy(notification) end
end)

return fanWibox
