local gears            = require("gears")
local awful            = require("awful")
local beautiful        = require("beautiful")
local wibox            = require("wibox")

-- Apple-style widgets
local workspace        = require("../wibgets/workspace")
local battery          = require("../wibgets/round_battery")
local wifi             = require("../wibgets/wifi_apple")
local floating         = require("../wibgets/floating_widgets")

-- Wrap widgets in pill-shaped containers
local function pill_container(widget, left, right)
    return wibox.widget {
        {
            widget,
            left   = left or 8,
            right  = right or 8,
            top    = 4,
            bottom = 4,
            widget = wibox.container.margin
        },
        bg     = beautiful.bg_normal or "#1a1b26",
        shape  = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, h/2)
        end,
        widget = wibox.container.background
    }
end

-- Set wallpaper
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

-- Setup wibar for each screen
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    -- Create the wibar (Apple-style: minimal, floating)
    s.topbar = awful.wibar({
        screen  = s,
        visible = true,
        stretch = false,
        margins = { top = 8, left = 12, right = 12 },
        height  = 36,
        width   = s.geometry.width - 24,
        bg      = beautiful.bg_normal or "#1a1b26",
        opacity = 0.95,
    })
    
    s.topbar.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 18)
    end

    -- Left side: Workspace indicator (direct, no pill for now)
    local left_widgets = {
        layout = wibox.layout.fixed.horizontal,
        spacing = 8,
        workspace,
    }

    -- Center: Clock
    local clock = wibox.widget.textclock("%I:%M %p", 1)
    clock.font = "JetBrainsMono Nerd Font Bold 11"
    clock.align = "center"
    
    local center_widgets = {
        layout = wibox.layout.align.horizontal,
        expand = "outside",
        nil,
        pill_container(clock, 16, 16),
        nil,
    }

    -- Right side: System widgets  
    local right_widgets = {
        layout = wibox.layout.fixed.horizontal,
        spacing = 8,
        pill_container(wifi, 8, 8),
        pill_container(battery, 8, 8),
        wibox.widget.systray(),
    }

    s.topbar:setup({
        layout = wibox.layout.align.horizontal,
        expand = "inside",
        { -- Left
            left_widgets,
            forced_width = 100,
            widget = wibox.container.background
        },
        center_widgets,
        { -- Right
            right_widgets,
            forced_width = 150,
            widget = wibox.container.background
        },
    })
end)

-- Initialize floating widgets
floating.init()
