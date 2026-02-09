local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local HOME = os.getenv("HOME")
local path_to_icons = HOME .. "/.local/icon/touchpad/"
local command = "cat /tmp/touchpadState"

local touchPadWibox = wibox.widget {
	{
		id = "icon",
		image = nil,
		widget = wibox.widget.imagebox,
	},
	widget = wibox.container.margin,
}

local function check_touchpad_state_and_update_icon()
	awful.spawn.easy_async_with_shell(command, function(out)
		local icon_path
		if out:match("disabled") then
			icon_path = path_to_icons .. "touchpad-disable.svg"
		else
			icon_path = path_to_icons .. "touchpad-enable.svg"
		end
		touchPadWibox.icon.image = gears.surface.load_uncached(icon_path)
	end)
end


check_touchpad_state_and_update_icon()
gears.timer {
	timeout = 5,
	autostart = true,
	callback = check_touchpad_state_and_update_icon,
}

return touchPadWibox
