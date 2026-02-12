local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local cairo     = require("lgi").cairo
local GLib = require("lgi").GLib

--------------------------------------------------
-- GLOBAL ANIMATION TIME (30 FPS)
--------------------------------------------------

local t = 0
local FPS = 30
local dt = 1 / FPS

--------------------------------------------------
-- STATE VARIABLES
--------------------------------------------------

local surge_timer = 0
local shock_timer = 0
local idle_timer  = 0
local hover_boost = 0

local last_level = 0
local was_connected = false

--------------------------------------------------
-- DRAW FUNCTION
--------------------------------------------------

local function draw_signal(level, connected)

    local size = 50
    local img  = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
    local cr   = cairo.Context(img)

    local cx, cy = size/2, size/2

    cr:set_line_cap(cairo.LineCap.ROUND)
    cr:set_line_join(cairo.LineJoin.ROUND)

    local strength = math.min(level / 100, 1)

    if not connected then
        strength = strength * 0.3
    end

    --------------------------------------------------
    -- Physics mapping
    --------------------------------------------------

    local omega   = 2 + 8 * strength         -- frequency
    local energy  = 0.2 + 0.8 * strength     -- amplitude scale
    local k       = 0.08 + 0.05 * (1-strength) -- decay
    local max_radius = 22
    local rings = 4

    for i = 1, rings do
        local r = i * (max_radius / rings)

        local attenuation = math.exp(-k * r)
        local wave = math.sin(omega * t - k * r)

        local amplitude = energy * attenuation * (0.6 + 0.5 * wave)

        if amplitude > 0.02 then
            local thickness = 3 + 10 * amplitude
            cr:set_line_width(thickness)

            cr:set_source_rgba(1, 1, 1, 0.8 * amplitude + 0.2)

            cr:new_sub_path()
            cr:arc(cx, cy, r, math.rad(200), math.rad(340))
            cr:stroke()
        end
    end

    if connected and level > 0 then
        cr:set_source_rgba(1,1,1,1)
        cr:arc(cx, cy + 10, 3.4, 0, 2 * math.pi)
        cr:fill()
    end

    return img
end

--------------------------------------------------
-- MODULE
--------------------------------------------------

local wireless = {}

local function worker(args)

    args            = args or {}
    local interface = args.interface or "wlan0"
    local timeout   = args.timeout or 5
    local font      = args.font or beautiful.font
    local indent    = args.indent or 3
    local onclick   = args.onclick
    local widget    = wibox.layout.fixed.horizontal()

    local current_level = 0
    local current_connected = false

    local net_icon  = wibox.widget.imagebox()
    local net_text  = wibox.widget.textbox()
    net_text.font   = font
    net_text:set_text(" N/A ")

    --------------------------------------------------
    -- HOVER INTERACTION
    --------------------------------------------------

    net_icon:connect_signal("mouse::enter", function()
        hover_boost = 0.3
    end)

    net_icon:connect_signal("mouse::leave", function()
        hover_boost = 0
    end)

    --------------------------------------------------
    -- SIGNAL POLLING
    --------------------------------------------------

local function net_update()
    local f = io.open("/proc/net/wireless", "r")
    if not f then return end

    local content = f:read("*all")
    f:close()

    local line = content:match(interface .. ":%s*(.+)")
    if line then
        local level = line:match("(%d+)%.")

        local signal_level = tonumber(level)

        if signal_level and signal_level > 0 then
            current_level = math.floor((signal_level / 70) * 100)
            current_connected = true
            widget.visible = true
        else
            current_level = 0
            current_connected = false
            widget.visible = false
        end
    else
        current_level = 0
        current_connected = false
        widget.visible = false
    end
end

    net_update()

    gears.timer.start_new(timeout, function()
        net_update()
        return true
    end)

    --------------------------------------------------
    -- ANIMATION LOOP
    --------------------------------------------------
  
local last_time = GLib.get_monotonic_time() / 1e6  -- seconds

gears.timer {
    timeout   = 1/60,   -- you can use 60 FPS now
    autostart = true,
    callback  = function()

        local now = GLib.get_monotonic_time() / 1e6
        local frame_dt = now - last_time
        last_time = now

        t = t + frame_dt

        if surge_timer > 0 then
            surge_timer = surge_timer - frame_dt * 2
        end

        if shock_timer > 0 then
            shock_timer = shock_timer - frame_dt * 3
        end

        net_icon:set_image(draw_signal(current_level, current_connected))
    end
}

    widget:add(net_icon)

    if onclick then
        widget:buttons(awful.util.table.join(
            awful.button({}, 1, function() awful.spawn(onclick) end)
        ))
    end

    return widget
end

return setmetatable(wireless, {
    __call = function(_, ...)
        return worker(...)
    end
})
