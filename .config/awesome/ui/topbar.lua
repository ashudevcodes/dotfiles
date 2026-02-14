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

------------------------------------------------------------
-- Power Mode Detection
------------------------------------------------------------

local power_save_mode = false

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local c = f:read("*all")
    f:close()
    return c
end

local function detect_power_mode()
    local ac = read_file("/sys/class/power_supply/AC/online")
    power_save_mode = not (ac and tonumber(ac) == 1)
    awesome.emit_signal("power::changed", power_save_mode)
end

detect_power_mode()

gears.timer {
    timeout   = beautiful.power_check_timeout or 15,
    autostart = true,
    callback  = detect_power_mode
}

------------------------------------------------------------
-- Poll Timeout Helper
------------------------------------------------------------

local function poll_timeout()
    return power_save_mode and (beautiful.poll_timeout_high or 15)
                              or (beautiful.poll_timeout_low  or 5)
end

------------------------------------------------------------
-- Simple Pill Container
------------------------------------------------------------

local function pill(widget, bg)
    return wibox.widget {
        {
            widget,
            left   = beautiful.widget_pad_x or 8,
            right  = beautiful.widget_pad_x or 8,
            top    = beautiful.widget_pad_y or 4,
            bottom = beautiful.widget_pad_y or 4,
            widget = wibox.container.margin
        },
        bg     = bg or beautiful.bg_normal,
        shape  = beautiful.widget_shape or function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, h / 2)
        end,
        widget = wibox.container.background
    }
end

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
        }
    }

    --------------------------------------------------------
    -- Widgets
    --------------------------------------------------------

    local ram_widget   = ram({ timeout = poll_timeout() })
    local battery_w    = battery
    local fan_widget   = fanwibox
    local touch_widget = touchpad.widget

    local wire_net = net_widgets.wireless()

    local wifi_pill = pill(wire_net)

    --------------------------------------------------------
    -- Right Layout
    --------------------------------------------------------

    local right_layout = wibox.layout.fixed.horizontal()
    right_layout.spacing = beautiful.widget_spacing or 8

    right_layout:add(pill(battery_w," "))
    right_layout:add(pill(fan_widget, " "))
    right_layout:add(pill(touch_widget, " "))
    right_layout:add(wifi_pill)
    right_layout:add(pill(wibox.widget.textclock(nil, 60)))
    right_layout:add(wibox.widget.systray())

    -- Toggle wifi pill visibility based on connection status
    awesome.connect_signal("net::wireless_status", function(connected, level)
        if wifi_pill then
            wifi_pill.visible = connected
        end
    end)

    --------------------------------------------------------
    -- Wibar
    --------------------------------------------------------

    s.topbar = awful.wibar {
        screen   = s,
        position = "top",
		height   = beautiful.topbar_height or 26,
		margins = 6,
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
