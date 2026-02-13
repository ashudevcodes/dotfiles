local wibox     = require("wibox")
local awful     = require("awful")
local gears     = require("gears")
local cairo     = require("lgi").cairo

--------------------------------------------------
-- Module
--------------------------------------------------

local wireless = {}

local function worker(args)

    args            = args or {}
    local interface = args.interface or "wlan0"
    local timeout   = args.timeout or 5
    local onclick   = args.onclick

    local widget = wibox.layout.fixed.horizontal()
    local net_icon = wibox.widget.imagebox()

    widget:add(net_icon)

    --------------------------------------------------
    -- Surface (REUSED)
    --------------------------------------------------

    local size = 50
    local surface = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
    local cr = cairo.Context(surface)

    --------------------------------------------------
    -- State
    --------------------------------------------------

    local current_connected = false

    local target_level = 0
    local display_level = 0

    local t = 0

    --------------------------------------------------
    -- Draw Function (NO allocations)
    --------------------------------------------------

    local function draw_signal(level, connected)

        cr:set_operator(cairo.Operator.CLEAR)
        cr:paint()
        cr:set_operator(cairo.Operator.OVER)

        local cx, cy = size/2, size/2

        cr:set_line_cap(cairo.LineCap.ROUND)
        cr:set_line_join(cairo.LineJoin.ROUND)

        local strength = math.min(level / 100, 1)
        if not connected then
            strength = strength * 0.3
        end

        local omega   = 2 + 8 * strength
        local energy  = 0.2 + 0.8 * strength
        local k       = 0.08 + 0.05 * (1-strength)

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
                cr:set_source_rgba(1,1,1,0.8 * amplitude + 0.2)

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

        net_icon.image = surface
    end

    --------------------------------------------------
    -- Controlled Animation Timer
    --------------------------------------------------

    local animation_timer

    local function start_animation()
        if not animation_timer.started then
            animation_timer:start()
        end
    end

    animation_timer = gears.timer {
        timeout   = 1/30,
        autostart = false,
        callback  = function()

            t = t + 0.03

            display_level =
                display_level +
                (target_level - display_level) * 0.08

            draw_signal(display_level, current_connected)

            if math.abs(display_level - target_level) < 0.5 then
                display_level = target_level
                animation_timer:stop()
            end
        end
    }

    --------------------------------------------------
    -- Signal Polling
    --------------------------------------------------

    local function net_update()
        local f = io.open("/proc/net/wireless", "r")
        if not f then return end

        local content = f:read("*all")
        f:close()

        local line = content:match(interface .. ":%s*(.+)")

        local level = 0
        local connected = false

        if line then
            local raw = tonumber(line:match("(%d+)%."))

            if raw and raw > 0 then
                level = math.floor((raw / 70) * 100)
                connected = true
            end
        end

        if level ~= target_level
           or connected ~= current_connected then

            target_level = level
            current_connected = connected
            start_animation()
        end
    end

    net_update()

    gears.timer {
        timeout   = timeout,
        autostart = true,
        callback  = net_update
    }

    if onclick then
        widget:buttons(awful.button({}, 1,
            function() awful.spawn(onclick) end))
    end

    return widget
end

return setmetatable(wireless, {
    __call = function(_, ...)
        return worker(...)
    end
})
