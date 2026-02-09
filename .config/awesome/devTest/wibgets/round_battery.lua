local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local unpack = unpack or table.unpack

-- Apple-style battery widget
local battery_widget = wibox.widget.base.make_widget()

battery_widget.percentage = 50
battery_widget.is_charging = false
battery_widget.hovered = false
battery_widget.popup_visible = false
battery_widget.pulse = 0

local popup = nil

-- Convert hex to RGB
local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber(hex:sub(1, 2), 16) / 255,
        tonumber(hex:sub(3, 4), 16) / 255,
        tonumber(hex:sub(5, 6), 16) / 255
    }
end

-- Get theme colors with Apple-style subtlety
local function get_colors()
    local fg = hex_to_rgb(beautiful.fg_normal or "#c0caf5")
    local bg = hex_to_rgb(beautiful.bg_normal or "#1a1b26")
    
    return {
        outline = {fg[1] * 0.6, fg[2] * 0.6, fg[3] * 0.6},
        fill = fg,
        bg = bg,
        charging = {0.3, 0.85, 0.4},
        low = {1.0, 0.6, 0.2},
        critical = {1.0, 0.3, 0.3},
        bolt = {1.0, 0.95, 0.4}
    }
end

-- Draw Apple-style battery
battery_widget.draw = function(self, _, cr, width, height)
    local colors = get_colors()
    
    -- Apple proportions
    local b_w, b_h = 24, 11
    local nub_w, nub_h = 2, 4
    local radius = 2.5
    local pad = 2
    
    local total_w = b_w + nub_w + 1
    local x = (width - total_w) / 2
    local y = (height - b_h) / 2
    
    -- Hover effect
    if self.hovered then
        cr:save()
        cr:translate(width/2, height/2)
        cr:scale(1.08, 1.08)
        cr:translate(-width/2, -height/2)
    end
    
    -- Draw battery body outline using rounded_rect shape
    cr:set_source_rgb(unpack(colors.outline))
    cr:set_line_width(1.2)
    cr:save()
    cr:translate(x, y)
    gears.shape.rounded_rect(cr, b_w, b_h, radius)
    cr:stroke()
    cr:restore()
    
    -- Draw nub (positive terminal) - small rounded rectangle
    cr:set_source_rgb(unpack(colors.outline))
    local nx = x + b_w + 1
    local ny = y + (b_h - nub_h) / 2
    cr:save()
    cr:translate(nx, ny)
    gears.shape.rounded_rect(cr, nub_w, nub_h, 1)
    cr:fill()
    cr:restore()
    
    -- Determine fill color
    local fill_color = colors.fill
    if self.is_charging then
        fill_color = colors.charging
    elseif self.percentage <= 10 then
        fill_color = colors.critical
    elseif self.percentage <= 20 then
        fill_color = colors.low
    end
    
    -- Draw fill level
    local max_fill_w = b_w - pad * 2
    local fill_w = max_fill_w * (self.percentage / 100)
    
    if fill_w > 0 then
        cr:set_source_rgb(unpack(fill_color))
        cr:save()
        cr:translate(x + pad, y + pad)
        
        -- Use rounded_bar for smooth fill
        if fill_w >= b_h - pad * 2 then
            gears.shape.rounded_bar(cr, fill_w, b_h - pad * 2)
        else
            -- Small fills use regular rounded rect
            gears.shape.rounded_rect(cr, fill_w, b_h - pad * 2, 1)
        end
        cr:fill()
        cr:restore()
    end
    
    -- Charging bolt - elegant, small
    if self.is_charging then
        local pulse_alpha = 0.7 + math.sin(self.pulse) * 0.3
        cr:set_source_rgba(colors.bolt[1], colors.bolt[2], colors.bolt[3], pulse_alpha)
        cr:set_line_width(1.5)
        cr:set_line_cap("round")
        
        local cx = width / 2
        local cy = height / 2
        local s = 4
        
        -- Clean bolt shape
        cr:move_to(cx, cy - s)
        cr:line_to(cx + s/2, cy)
        cr:line_to(cx - 0.5, cy)
        cr:line_to(cx, cy + s)
        cr:line_to(cx - s/2, cy)
        cr:line_to(cx + 0.5, cy)
        cr:close_path()
        cr:fill()
    end
    
    if self.hovered then
        cr:restore()
    end
end

-- Popup
local function create_popup()
    return awful.popup {
        widget = {
            {
                {
                    text = "Battery",
                    font = beautiful.font or "JetBrainsMono Nerd Font Bold 11",
                    widget = wibox.widget.textbox
                },
                {
                    id = "pct",
                    text = "50%",
                    font = beautiful.font or "JetBrainsMono Nerd Font 10",
                    widget = wibox.widget.textbox
                },
                {
                    id = "status",
                    text = "",
                    font = beautiful.font or "JetBrainsMono Nerd Font 10",
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.vertical,
                spacing = 4
            },
            margins = 12,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal or "#1a1b26",
        fg = beautiful.fg_normal or "#c0caf5",
        border_color = beautiful.border_normal or "#565f89",
        border_width = 1,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 8)
        end,
        visible = false,
        ontop = true
    }
end

local function update_popup()
    if not popup then return end
    local pct_w = popup.widget:get_children_by_id("pct")[1]
    local status_w = popup.widget:get_children_by_id("status")[1]
    if pct_w then pct_w.text = string.format("%d%%", battery_widget.percentage) end
    if status_w then
        status_w.text = battery_widget.is_charging and "Charging" or "On Battery"
    end
end

-- Battery data
function battery_widget:update()
    awful.spawn.easy_async_with_shell(
        "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1",
        function(capacity)
            local pct = tonumber(capacity)
            if pct then
                battery_widget.percentage = pct
                battery_widget:emit_signal("widget::redraw_needed")
                update_popup()
            end
        end
    )
    
    awful.spawn.easy_async_with_shell(
        "cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1",
        function(status)
            local old = battery_widget.is_charging
            battery_widget.is_charging = status and (status:match("Charging") or status:match("Full"))
            if battery_widget.is_charging ~= old then
                battery_widget:emit_signal("widget::redraw_needed")
                update_popup()
            end
        end
    )
end

-- Signals
battery_widget:connect_signal("mouse::enter", function()
    battery_widget.hovered = true
    battery_widget:emit_signal("widget::redraw_needed")
end)

battery_widget:connect_signal("mouse::leave", function()
    battery_widget.hovered = false
    battery_widget:emit_signal("widget::redraw_needed")
    if battery_widget.popup_visible then
        popup.visible = false
        battery_widget.popup_visible = false
    end
end)

battery_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        if not popup then popup = create_popup() end
        if not battery_widget.popup_visible then
            update_popup()
            popup.visible = true
            battery_widget.popup_visible = true
            gears.timer {
                timeout = 3,
                autostart = true,
                single_shot = true,
                callback = function()
                    if battery_widget.popup_visible then
                        popup.visible = false
                        battery_widget.popup_visible = false
                    end
                end
            }
        else
            popup.visible = false
            battery_widget.popup_visible = false
        end
    elseif button == 3 then
        awful.menu({
            items = {
                { "Sleep", function() awful.spawn("systemctl suspend") end },
                { "Lock", function() awful.spawn("i3lock -c 000000") end },
                { "Shut Down", function() awful.spawn("systemctl poweroff") end }
            }
        }):show()
    end
end)

-- Animation
gears.timer {
    timeout = 0.08,
    autostart = true,
    callback = function()
        if battery_widget.is_charging then
            battery_widget.pulse = battery_widget.pulse + 0.4
            battery_widget:emit_signal("widget::redraw_needed")
        end
    end
}

-- Update timer
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function()
        battery_widget:update()
    end
}

battery_widget.fit = function(self, context, width, height)
    return 32, height
end

battery_widget:update()
return battery_widget
