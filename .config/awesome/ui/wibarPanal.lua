local gears            = require("gears")
local awful            = require("awful")
local beautiful        = require("beautiful")
local net_widgets      = require("../wibgets/netWidget")
local battery          = require("../wibgets/round_battery")
local volume           = require("../wibgets/pipwirebox")
local fanwibox         = require("../wibgets/fan")
local ram              = require("../wibgets/ram")
local touchpad         = require("../wibgets/touchpad")
local wibox            = require("wibox")


local ramLogo          = wibox.container.margin(ram({ timeout = 5 }), 10)

local function pill_container(widget, left, right,usbg)
    return wibox.widget {
        {
            widget,
            left   = left or 8,
            right  = right or 8,
            top    = 4,
            bottom = 4,
            widget = wibox.container.margin
        },
        bg     = usbg or beautiful.bg_normal,
        shape  = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, h/2)
        end,
        widget = wibox.container.background
    }
end


local combined_widget  = wibox.widget {
	{
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

local wire_net         = net_widgets.wireless({
	widget       = wibox.layout.fixed.vertical(),
	popup_signal = false,
})

local wifi_pill        = pill_container(wire_net, 8,8)

wire_net._pill_container = wifi_pill

wifi_pill.visible = wire_net.visible


screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

	awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])
	
	s.wifi_pill = wifi_pill

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
			stretch = false,
			margins = 5,
			width = 1885,
		})

	s.topbar:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",

		{
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
	  ramLogo,
		},
		centered_widgets,
		{
			layout = wibox.layout.fixed.horizontal,
	  pill_container(battery, 8, 8,""),
	  wifi_pill,
	  pill_container(fanwibox,nil,nil,""),
	  pill_container(touchpad,nil,nil,""),
	  pill_container(wibox.widget.textclock),
			wibox.widget.systray(),
		},
	})
end)
