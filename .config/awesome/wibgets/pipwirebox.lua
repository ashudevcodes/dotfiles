local wibox     = require("wibox")
local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful")

local volume    = {}

local function get_volume(callback)
	awful.spawn.easy_async_with_shell(
		"wpctl get-volume @DEFAULT_SINK@ 2>/dev/null || echo 'Volume: -1'",
		function(vol)
			local v = string.match(vol, "([%d%.]+)")
			v = tonumber(v)
			if not v or v < 0 then
				callback(nil, nil)
				return
			end

			local muted = vol:match("%[MUTED%]") ~= nil

			callback(v * 100, muted)
		end
	)
end


local HOME = os.getenv("HOME")
local path_to_icons = HOME .. "/.local/icon/volume/"
local function draw_icon(vol, muted)
	if muted or not vol then
		return path_to_icons .. "mute-user-svgrepo-com.svg"
	else
		return path_to_icons .. "headphones-round-sound-svgrepo-com.svg"
	end
end

local function worker(args)
	args          = args or {}
	local timeout = args.timeout or 1
	local font    = args.font or beautiful.font
	local onclick = args.onclick
	local widget  = args.widget == nil and wibox.layout.fixed.horizontal() or args.widget

	local icon    = wibox.widget.imagebox()
	local text    = wibox.widget.textbox()
	text.font     = font
	text:set_text("N/A")

	local function update()
		get_volume(function(vol, muted)
			if vol == nil then
				text:set_text("N/A")
				icon:set_image(nil)
				return
			end
			text:set_text(muted and "" or string.format("% d%%", vol))
			icon:set_image(draw_icon(vol, muted))
		end)
	end

	update()
	gears.timer.start_new(timeout, function()
		update()
		return true
	end)

	if widget then
		widget:add(icon)
		widget:add(text)
		if onclick then
			widget:buttons(gears.table.join(
				awful.button({}, 1, function() awful.spawn(onclick) end)
			))
		end
	end

	return widget
end

return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
