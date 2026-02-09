local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local floating_widgets = {}

local widgets = {}
local widget_container = nil

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber(hex:sub(1, 2), 16) / 255,
        tonumber(hex:sub(3, 4), 16) / 255,
        tonumber(hex:sub(5, 6), 16) / 255
    }
end

-- Create glassmorphism background effect
local function create_glass_widget(x, y, width, height, content)
    local glass = wibox({
        x = x,
        y = y,
        width = width,
        height = height,
        bg = beautiful.bg_normal or "#1a1b26",
        ontop = false,
        visible = true,
        type = "normal"
    })
    
    glass.bg = "#1a1b26CC" -- Semi-transparent
    glass.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 20)
    end
    
    glass:setup({
        widget = wibox.container.margin,
        margins = 16,
        content
    })
    
    return glass
end

-- Clock widget (iOS-style)
function floating_widgets.create_clock(x, y)
    local time_widget = wibox.widget.textclock("%I:%M", 1)
    time_widget.font = "JetBrainsMono Nerd Font Bold 32"
    time_widget.align = "center"
    
    local date_widget = wibox.widget.textclock("%A, %B %d", 60)
    date_widget.font = "JetBrainsMono Nerd Font 14"
    date_widget.align = "center"
    
    local widget_content = {
        layout = wibox.layout.fixed.vertical,
        spacing = 4,
        time_widget,
        date_widget
    }
    
    local glass = create_glass_widget(x, y, 140, 100, widget_content)
    table.insert(widgets, glass)
    return glass
end

-- Weather widget placeholder
function floating_widgets.create_weather(x, y)
    local icon = wibox.widget.textbox("")
    icon.font = "JetBrainsMono Nerd Font 32"
    icon.text = ""
    icon.align = "center"
    
    local temp = wibox.widget.textbox("72°")
    temp.font = "JetBrainsMono Nerd Font Bold 28"
    temp.align = "center"
    
    local condition = wibox.widget.textbox("Sunny")
    condition.font = "JetBrainsMono Nerd Font 12"
    condition.align = "center"
    
    local widget_content = {
        layout = wibox.layout.fixed.vertical,
        spacing = 2,
        icon,
        temp,
        condition
    }
    
    local glass = create_glass_widget(x, y, 120, 100, widget_content)
    table.insert(widgets, glass)
    return glass
end

-- Battery widget (large)
function floating_widgets.create_battery_widget(x, y)
    local percent = wibox.widget.textbox("50%")
    percent.font = "JetBrainsMono Nerd Font Bold 28"
    percent.align = "center"
    
    local status = wibox.widget.textbox("Battery")
    status.font = "JetBrainsMono Nerd Font 12"
    status.align = "center"
    
    local widget_content = {
        layout = wibox.layout.fixed.vertical,
        spacing = 4,
        percent,
        status
    }
    
    local glass = create_glass_widget(x, y, 100, 80, widget_content)
    
    -- Update battery
    gears.timer {
        timeout = 30,
        autostart = true,
        callback = function()
            awful.spawn.easy_async_with_shell(
                "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1",
                function(capacity)
                    local pct = tonumber(capacity)
                    if pct then
                        percent.text = pct .. "%"
                    end
                end
            )
        end
    }
    
    table.insert(widgets, glass)
    return glass
end

-- Initialize floating widgets on desktop
function floating_widgets.init()
    local screen = screen.primary
    local gap = 20
    local start_x = screen.geometry.width - 160
    local start_y = 100
    
    -- Create clock
    floating_widgets.create_clock(start_x, start_y)
    
    -- Create battery
    floating_widgets.create_battery_widget(start_x, start_y + 120)
end

-- Show/hide all widgets
function floating_widgets.toggle_visibility()
    for _, widget in ipairs(widgets) do
        widget.visible = not widget.visible
    end
end

return floating_widgets
