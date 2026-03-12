local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local net_widgets = require("../wibgets/netWidget")
local battery     = require("../wibgets/round_battery")
local fanwibox    = require("../wibgets/fan")
local ram         = require("../wibgets/ram")
local touchpad    = require("../wibgets/touchpad")

local topbar = {}

local cup = wibox.widget{
    markup = "  ",
	font = "JetBrainsMono 16",
    halign = "top",
    valign = "right",
    widget = wibox.widget.textbox
}
------------------------------------------------------------
-- Simple Pill Container
------------------------------------------------------------

local function pill(widget, bg)
    return wibox.widget {
        {
            widget,
            left   = beautiful.widget_pad_x or 8,
            right  = beautiful.widget_pad_x or 8,
            top    = beautiful.widget_pad_y or 7*1/2,
            bottom = beautiful.widget_pad_y or 7*1/2,
            widget = wibox.container.margin
        },
        bg     = bg or beautiful.bg_normal,
        shape  = beautiful.widget_shape or function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, h / 2)
        end,
        widget = wibox.container.background
    }
end

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),

    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    awful.button({}, 3, awful.tag.viewtoggle),

    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),

    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)
------------------------------------------------------------
-- Create Topbar
------------------------------------------------------------

function topbar.create(s)

    --------------------------------------------------------
    -- Wallpaper
    --------------------------------------------------------

    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end

    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    --------------------------------------------------------
    -- Taglist
    --------------------------------------------------------

    local taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
        layout  = {
            spacing = beautiful.tag_spacing or 6,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox
                },
                left   = beautiful.tag_margin_x or 12,
                right  = beautiful.tag_margin_x or 12,
                top    = beautiful.tag_margin_y or 6,
                bottom = beautiful.tag_margin_y or 6,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,

			 create_callback = function(self)
			  self:connect_signal("mouse::enter", function()
				  local w = mouse.current_wibox
				  if w then
					  w.cursor = "hand2"
				  end
			  end)

			  self:connect_signal("mouse::leave", function()
				  local w = mouse.current_wibox
				  if w then
					  w.cursor = "left_ptr"
				  end
			  end)
		  end
		  }
    }

    --------------------------------------------------------
    -- Widgets
    --------------------------------------------------------

    local ram_widget   = ram()
    local battery_w    = battery
    local fan_widget   = fanwibox
    local touch_widget = touchpad.widget
	local wire_net = net_widgets.wireless()

  local widgets_table = {
	{1,pill(battery_w),true},
	{2,pill(fan_widget),true},
	{3,pill(touch_widget),true},
	{4,pill(wire_net),true},
	{5,pill(cup),true},
  }


    --------------------------------------------------------
    -- Right Layout
    --------------------------------------------------------

    local right_layout = wibox.layout.fixed.horizontal()
    right_layout.spacing = beautiful.widget_spacing or 8



    right_layout:insert(widgets_table[1][1],widgets_table[1][2])
    right_layout:insert(widgets_table[2][1],widgets_table[2][2])
    right_layout:insert(widgets_table[3][1],widgets_table[3][2])

  awesome.connect_signal("net::wireless_status", function(connected,level)
	print(level,connected)
	if level > 0 then
	  if  widgets_table[4][3] == true then
		right_layout:insert(widgets_table[4][1],widgets_table[4][2])
		widgets_table[4][3] = false
	  end
	elseif level == 0 then
	  widgets_table[4][3] = true
	  right_layout:remove_widgets(widgets_table[4][2])
	end
  end)

  awesome.connect_signal("wakeup::screen_state",function (dpms_enabled)
	if dpms_enabled then
	  widgets_table[5][3] = false
	  right_layout:insert(1,widgets_table[5][2])
	elseif widgets_table[5][3] == false then
	  right_layout:remove_widgets(widgets_table[5][2])
	end
  end )

  right_layout:add(pill(wibox.widget.textclock(nil, 60)))
    right_layout:add(wibox.widget.systray())

    --------------------------------------------------------
    -- Wibar
    --------------------------------------------------------

    s.topbar = awful.wibar {
        screen   = s,
        position = "top",
		margins = 8,
        stretch  = true
    }

    s.topbar:setup {
        layout = wibox.layout.align.horizontal,

        {
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.left_layout_spacing or 8,
            taglist,
            ram_widget,
        },

        nil,

        right_layout,
    }

    return s.topbar
end

return topbar
