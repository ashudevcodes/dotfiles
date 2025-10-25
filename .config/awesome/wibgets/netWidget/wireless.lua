local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local cairo     = require("lgi").cairo

local theme     = beautiful.get()

-- Draw the Wi-Fi signal or disconnected icon
local function draw_signal(level, connected)
	local img    = cairo.ImageSurface.create(cairo.Format.ARGB32, 32, 32)
	local cr     = cairo.Context(img)
	local cx, cy = 16, 16


	cr:set_source(gears.color(theme.fg_normal))
	cr:set_line_cap(cairo.LineCap.ROUND)
	cr:set_line_width(2)

	local radii = { 8, 7, 3 }

	for i, r in ipairs(radii) do
		local threshold = (4 - i) * 25
		if level > threshold then
			cr:arc(cx, cy, r, 200 * math.pi / 180, 340 * math.pi / 180)
			cr:stroke()
		end
	end

	if level > 0 then
		cr:arc(cx, cy + 6, 1.5, 0, 2 * math.pi)
		cr:fill()
	end

	return img
end

local wireless = {}

local function worker(args)
	args            = args or {}
	local interface = args.interface or "wlan0"
	local timeout   = args.timeout or 5
	local font      = args.font or beautiful.font
	local indent    = args.indent or 3
	local onclick   = args.onclick
	local widget    = args.widget == nil and wibox.layout.fixed.horizontal() or args.widget

	local net_icon  = wibox.widget.imagebox(draw_signal(0, false))
	local net_text  = wibox.widget.textbox()
	net_text.font   = font
	net_text:set_text(" N/A ")

	local function net_update()
		awful.spawn.easy_async_with_shell(string.format(
				"grep %s /proc/net/wireless | awk '{printf(\"%%3.0f\", ($3/70)*100)}'", interface),
			function(stdout)
				local signal_level = tonumber(stdout)
				if not signal_level or signal_level <= 0 then
					net_text:set_text(" N/A ")
					net_icon:set_image(draw_signal(0, false))
				else
					net_text:set_text(string.format("%" .. indent .. "d%%", signal_level))
					net_icon:set_image(draw_signal(signal_level, true))
				end
			end
		)
	end

	net_update()
	gears.timer.start_new(timeout, function()
		net_update()
		return true
	end)

	if widget then
		widget:add(net_icon)
		widget:add(net_text)
		if onclick then
			widget:buttons(awful.util.table.join(
				awful.button({}, 1, function() awful.util.spawn(onclick) end)
			))
		end
	end

	return widget
end

return setmetatable(wireless, { __call = function(_, ...) return worker(...) end })
