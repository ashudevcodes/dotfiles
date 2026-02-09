local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- 1. Define your widget content (using the style from your image)
local my_desktop_widget = wibox.widget {
    {
        {
            text   = "Nasmaste Ashu",
            font   = beautiful.font,
            align  = "center",
            widget = wibox.widget.textbox,
        },
        margins = 20,
        widget  = wibox.container.margin,
    },
    bg     = "#1a1a1acc", -- Translucent background
    shape  = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 12)
    end,
    widget = wibox.container.background,
}

-- 2. Create the Wibox container
local desktop_container = wibox({
    visible = true,
    ontop   = false,     -- Keep it BELOW windows
    type    = "desktop", -- Tells the window manager to treat it as background
    bg      = "#00000000", -- Fully transparent wibox (container)
    width   = 300,
    height  = 150,
    screen  = s,         -- Use 's' if inside a screen iterator, or screen[1]
})

-- 3. Position it on the screen
awful.placement.bottom_left(desktop_container, { 
    margins = { bottom = 50, left = 50 } 
})

-- 4. Set the widget
desktop_container:setup {
    my_desktop_widget,
    layout = wibox.layout.align.vertical,
}

