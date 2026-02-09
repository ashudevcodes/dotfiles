local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Apple-style workspace widget
local workspace_container = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = 8,
    forced_width = 80,
}

-- Wrap in background for proper display
local workspace_widget = wibox.widget {
    {
        workspace_container,
        left = 8,
        right = 8,
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_normal or "#1a1b26",
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, h/2)
    end,
    widget = wibox.container.background,
}

-- Current tag tracker
workspace_widget.current_tag = 1

-- Build dots
local function build_dots()
    workspace_container:reset()
    for i = 1, 4 do
        local is_active = i == workspace_widget.current_tag
        local dot = wibox.widget {
            markup = is_active 
                and "<span foreground='#c0caf5' font='JetBrainsMono Nerd Font 10'>●</span>" 
                or "<span foreground='#565f89' font='JetBrainsMono Nerd Font 8'>○</span>",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox,
            forced_width = 16,
        }
        workspace_container:add(dot)
    end
end

-- Initial build
build_dots()

-- Update on tag change
tag.connect_signal("property::selected", function(t)
    workspace_widget.current_tag = t.index
    build_dots()
end)

-- Click to switch tags
workspace_widget:connect_signal("button::press", function(_, x, y, button)
    if button == 1 then
        local dot_width = 80 / 4
        local clicked = math.ceil(x / dot_width)
        if clicked >= 1 and clicked <= 4 then
            local screen = awful.screen.focused()
            local tag = screen.tags[clicked]
            if tag then 
                tag:view_only() 
            end
        end
    end
end)

return workspace_widget
