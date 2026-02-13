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
-- POWER MODE DETECTION
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
    if ac and tonumber(ac) == 1 then
        power_save_mode = false
    else
        power_save_mode = true
    end
end

detect_power_mode()

-- Recheck power state every 15s
gears.timer {
    timeout   = 15,
    autostart = true,
    callback  = detect_power_mode
}

------------------------------------------------------------
-- Simple Pill Container
------------------------------------------------------------

local function pill(widget, bg)
    return wibox.widget {
        {
            widget,
            left   = 8,
            right  = 8,
            top    = 4,
            bottom = 4,
            widget = wibox.container.margin
        },
        bg     = bg or beautiful.bg_normal,
        shape  = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, h/2)
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
            spacing = 6,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox
                },
                left   = 16,
                right  = 16,
                top    = 6,
                bottom = 6,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        }
    }

    --------------------------------------------------------
    -- Widgets
    --------------------------------------------------------

    local ram_widget   = ram({ timeout = power_save_mode and 15 or 5 })
    local battery_w    = battery
    local fan_widget   = fanwibox
    local touch_widget = touchpad

    local wire_net = net_widgets.wireless({
        timeout = power_save_mode and 15 or 5
    })

    local wifi_pill = pill(wire_net)

    --------------------------------------------------------
    -- Right Layout
    --------------------------------------------------------

    local right_layout = wibox.layout.fixed.horizontal()
    right_layout.spacing = 8

    right_layout:add(battery_w)
    right_layout:add(pill(fan_widget))
    right_layout:add(pill(touch_widget))
    right_layout:add(wifi_pill)
    right_layout:add(pill(wibox.widget.textclock(nil, 60)))
    right_layout:add(wibox.widget.systray())

    --------------------------------------------------------
    -- Wibar
    --------------------------------------------------------

    s.topbar = awful.wibar({
        screen   = s,
        position = "top",
        height   = 26,
        margins  = 6,
        stretch  = true,
    })

    s.topbar:setup({
        layout = wibox.layout.align.horizontal,

        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            taglist,
            ram_widget,
        },

        nil,

        right_layout,
    })

    return s.topbar
end

return topbar
