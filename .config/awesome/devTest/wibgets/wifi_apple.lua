local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Lua 5.2+ compatibility
local unpack = unpack or table.unpack

local wifi_widget = wibox.widget.base.make_widget()

wifi_widget.connected = false
wifi_widget.signal_strength = 0
wifi_widget.hovered = false
wifi_widget.popup_visible = false

local popup = nil

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber(hex:sub(1, 2), 16) / 255,
        tonumber(hex:sub(3, 4), 16) / 255,
        tonumber(hex:sub(5, 6), 16) / 255
    }
end

local function get_colors()
    local fg = hex_to_rgb(beautiful.fg_normal or "#c0caf5")
    return {
        fg = fg,
        inactive = {fg[1] * 0.4, fg[2] * 0.4, fg[3] * 0.4}
    }
end

-- Draw WiFi icon with arc bars (Apple-style)
wifi_widget.draw = function(self, _, cr, width, height)
    local colors = get_colors()
    local color = self.connected and colors.fg or colors.inactive
    
    local cx = width / 2
    local cy = height / 2 + 1
    local base_radius = 3
    
    -- Hover scale
    if self.hovered then
        cr:save()
        cr:translate(cx, cy)
        cr:scale(1.15, 1.15)
        cr:translate(-cx, -cy)
    end
    
    cr:set_source_rgb(unpack(color))
    cr:set_line_width(1.5)
    cr:set_line_cap("round")
    
    -- Draw WiFi arcs (3 arcs like Apple)
    local max_bars = self.connected and math.max(1, math.ceil(self.signal_strength / 33)) or 0
    
    for i = 1, 3 do
        local radius = base_radius + (i - 1) * 2.5
        local alpha = (i <= max_bars) and 1.0 or 0.2
        cr:set_source_rgba(color[1], color[2], color[3], alpha)
        
        cr:arc(cx, cy + 2, radius, math.pi * 0.8, math.pi * 2.2)
        cr:stroke()
    end
    
    if self.hovered then
        cr:restore()
    end
end

local function create_popup()
    return awful.popup {
        widget = {
            {
                {
                    text = "Wi-Fi",
                    font = beautiful.font or "JetBrainsMono Nerd Font Bold 11",
                    widget = wibox.widget.textbox
                },
                {
                    id = "status",
                    text = "Connected",
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
    local status = popup.widget:get_children_by_id("status")[1]
    if status then
        status.text = wifi_widget.connected and "Connected" or "Not Connected"
    end
end

function wifi_widget:update()
    awful.spawn.easy_async_with_shell(
        "iwgetid -r 2>/dev/null || echo ''",
        function(ssid)
            self.connected = ssid ~= "" and ssid ~= nil
            
            if self.connected then
                awful.spawn.easy_async_with_shell(
                    "awk '/wlan0|wlp/ {print int($3 * 100 / 70)}' /proc/net/wireless 2>/dev/null || echo 0",
                    function(strength)
                        self.signal_strength = tonumber(strength) or 0
                        self:emit_signal("widget::redraw_needed")
                        update_popup()
                    end
                )
            else
                self.signal_strength = 0
                self:emit_signal("widget::redraw_needed")
                update_popup()
            end
        end
    )
end

wifi_widget:connect_signal("mouse::enter", function()
    wifi_widget.hovered = true
    wifi_widget:emit_signal("widget::redraw_needed")
end)

wifi_widget:connect_signal("mouse::leave", function()
    wifi_widget.hovered = false
    wifi_widget:emit_signal("widget::redraw_needed")
    if wifi_widget.popup_visible then
        popup.visible = false
        wifi_widget.popup_visible = false
    end
end)

wifi_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        if not popup then popup = create_popup() end
        if not wifi_widget.popup_visible then
            update_popup()
            popup.visible = true
            wifi_widget.popup_visible = true
            gears.timer {
                timeout = 3,
                autostart = true,
                single_shot = true,
                callback = function()
                    if wifi_widget.popup_visible then
                        popup.visible = false
                        wifi_widget.popup_visible = false
                    end
                end
            }
        else
            popup.visible = false
            wifi_widget.popup_visible = false
        end
    elseif button == 3 then
        awful.spawn("nm-connection-editor")
    end
end)

gears.timer {
    timeout = 5,
    autostart = true,
    callback = function()
        wifi_widget:update()
    end
}

wifi_widget.fit = function(self, context, width, height)
    return 32, height
end

wifi_widget:update()
return wifi_widget
