local gears            = require("gears")
local awful            = require("awful")
local beautiful        = require("beautiful")
local net_widgets      = require("../wibgets/netWidget")
local batteryWibox     = require("../wibgets/battery")
local volume           = require("../wibgets/pipwirebox")
local fanwibox         = require("../wibgets/fan")
local ram              = require("../wibgets/ram")
local wibox            = require("wibox")

local mytextclock      = wibox.widget.textclock()

local ramLogo          = wibox.container.margin(ram({ timeout = 5 }), 10)
local volumeContainer  = wibox.container.margin(volume(), 0, 8, 8, 6)
local fanConainer      = wibox.container.margin(fanwibox, 0, 0, 5, 5)

local wire_net         = net_widgets.wireless({
	widget       = wibox.layout.fixed.vertical(),
	popup_signal = false,
})

local wire_netContiner = wibox.container.margin(wire_net, 0, 8, 4, 0)

local combined_widget  = wibox.widget {
	{
		fanConainer,
		mytextclock,
		fanConainer,
		spacing = 10,
		layout = wibox.layout.fixed.horizontal,
	},
	widget = wibox.container.margin
}
local centered_widgets = wibox.container.place(combined_widget, {
	halign = "center",
	valign = "center"
})

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

	awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = {
			font = beautiful.font,
		},
		layout = {
			spacing = 2,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				left   = 10,
				right  = 10,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	s.topbar = awful.wibar(
		{
			screen = s,
			visible = true,
			width = 1885,
		})

	s.topbar:setup({
		layout = wibox.layout.align.horizontal,

		{
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
			ramLogo,
		},
		centered_widgets,
		{
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			wire_netContiner,
			volumeContainer,
			batteryWibox({ margin_right = 10, display_notification = true }),
		},
	})
end)
