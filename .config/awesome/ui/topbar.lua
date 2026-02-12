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

    --------------------------------------------------------
    -- Tags
    --------------------------------------------------------
    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    --------------------------------------------------------
    -- Taglist (DEFAULT, no animation)
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
    -- Widgets (per screen)
    --------------------------------------------------------
    local ram_widget   = ram({ timeout = 5 })
    local battery_w    = battery
    local fan_widget   = fanwibox
    local touch_widget = touchpad

  local wire_net = net_widgets.wireless({
	widget       = wibox.layout.fixed.vertical(),
	popup_signal = false,
  })

  -- Wrap wifi inside pill
  local wifi_pill = pill(wire_net)

  -- Function to check WiFi connection
local function update_wifi_visibility()
    awful.spawn.easy_async_with_shell(
        "cat /proc/net/wireless | grep -v Inter | grep -v face",
        function(stdout)
            if stdout and stdout:match("%S") then
                wifi_pill.visible = true
            else
                wifi_pill.visible = false
            end
        end
    )
end

  -- Initial check
  update_wifi_visibility()

  -- Recheck every 10 seconds
  gears.timer {
	timeout   = 10,
	autostart = true,
	callback  = update_wifi_visibility
  }

    --------------------------------------------------------
    -- Right Layout
    --------------------------------------------------------
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout.spacing = 8

    right_layout:add(battery_w)
    right_layout:add(pill(fan_widget))
    right_layout:add(pill(touch_widget))
    right_layout:add(wifi_pill)
    right_layout:add(pill(wibox.widget.textclock()))
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

        -- Left
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 8,
            taglist,
            ram_widget,
        },

        -- Center
        nil,

        -- Right
        right_layout,
    })

    return s.topbar
end

return topbar
