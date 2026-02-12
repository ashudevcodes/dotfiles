local awful    = require("awful")
local gears    = require("gears")
local wibox    = require("wibox")
local naughty  = require("naughty")
local cairo    = require("lgi").cairo

local home = os.getenv("HOME")
local path_to_icons = home .. "/.local/icon/fan/"
local command = home .. "/.local/bin/lappyfan state"

-------------------------------------------------
-- Config
-------------------------------------------------
local size = 32
local fps = 30
local dt = 1 / fps

-- physics constants
local inertia     = 0.18
local damping     = 0.05
local torque_gain = 1.2

-------------------------------------------------
-- Temperature Reader
-------------------------------------------------
local function get_temp()
    local f = io.open("/sys/class/thermal/thermal_zone0/temp", "r")
    if not f then return 40 end
    local t = tonumber(f:read("*all"))
    f:close()
    if not t then return 40 end
    return t / 1000
end

-------------------------------------------------
-- Load SVG once
-------------------------------------------------
local fan_surface = gears.surface.load_uncached(path_to_icons .. "fan-off.svg")

-------------------------------------------------
-- Create reusable drawing surface
-------------------------------------------------
local rotating_surface = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
local cr = cairo.Context(rotating_surface)

local fan_image = wibox.widget {
    image  = rotating_surface,
    resize = true,
    widget = wibox.widget.imagebox,
}

local fanwibox = wibox.widget {
    {
        fan_image,
        margins = 0,
        widget  = wibox.container.margin
    },
    buttons = gears.table.join(
        awful.button({}, 1, function() awful.spawn(command) end)
    ),
    layout = wibox.layout.fixed.horizontal
}

-------------------------------------------------
-- Physics variables
-------------------------------------------------
local rotation      = 0
local speed         = 0
local target_speed  = 0
local time          = 0

-- temperature animation
local current_temp  = 40
local display_temp  = 40

-------------------------------------------------
-- Motor Physics Loop (30 FPS)
-------------------------------------------------
gears.timer {
    timeout   = dt,
    autostart = true,
    callback  = function()

        time = time + dt

        -- Smooth temperature interpolation
        display_temp = display_temp + (current_temp - display_temp) * 0.08

        -------------------------------------------------
        -- Motor physics
        -------------------------------------------------
        local torque = (target_speed - speed) * torque_gain
        local acceleration = (torque - damping * speed) / inertia
        speed = speed + acceleration * dt

        if math.abs(speed) < 0.0001 and target_speed == 0 then
            speed = 0
        end

        rotation = (rotation + speed) % (2 * math.pi)

        -------------------------------------------------
        -- Clear surface
        -------------------------------------------------
        cr:set_operator(cairo.Operator.CLEAR)
        cr:paint()
        cr:set_operator(cairo.Operator.OVER)

        -------------------------------------------------
        -- Draw rotated fan
        -------------------------------------------------
        local w = fan_surface:get_width()
        local h = fan_surface:get_height()
        local scale = math.min(size / w, size / h)

        local wobble = 0
        if speed < 0.15 and speed > 0 then
            wobble = 0.02 * math.sin(8 * time)
        end

        cr:save()
        cr:translate(size/2, size/2)
        cr:rotate(rotation + wobble)
        cr:scale(scale, scale)
        cr:translate(-w/2, -h/2)

        cr:set_source_surface(fan_surface, 0, 0)
        cr:paint()

        -------------------------------------------------
        -- Temperature Color Overlay
        -------------------------------------------------
        local r, g, b = 1, 1, 1

        if display_temp < 45 then
            r, g, b = 0.4, 0.7, 1        -- cool blue
        elseif display_temp < 65 then
            r, g, b = 1, 1, 1            -- neutral
        elseif display_temp < 80 then
            r, g, b = 1, 0.6, 0.2        -- orange
        else
            r, g, b = 1, 0.2, 0.2        -- red
        end

        local intensity = math.min((display_temp - 40) / 40, 1)

        cr:set_operator(cairo.Operator.ATOP)
        cr:set_source_rgba(r, g, b, 0.6 * intensity)
        cr:paint()
        cr:set_operator(cairo.Operator.OVER)

        cr:restore()

        fan_image:emit_signal("widget::redraw_needed")
    end
}

-------------------------------------------------
-- Update fan state + temperature
-------------------------------------------------
local function updatefanicon()
    awful.spawn.easy_async_with_shell(command, function(out)
        if out and out:match("running") then
            target_speed = 0.5
        else
            target_speed = 0
        end
    end)

    current_temp = get_temp()
end

updatefanicon()

gears.timer {
    timeout   = 5,
    autostart = true,
    callback  = updatefanicon
}

-------------------------------------------------
-- Notification
-------------------------------------------------
local notification
local fanState

local function show_fan_status()
    awful.spawn.easy_async_with_shell(command, function(stdout)

	if stdout:gsub("\n+$"," ") ~= 0 then
	  fanState = "Fan is Chilling"
	else
	  fanState = "Fan is Grinding"
	end

        if notification then naughty.destroy(notification) end

        notification = naughty.notify {
            text     = fanState,
            icon     = path_to_icons .. "fan-off.svg",
            title    = "Fan Status",
            position = "top_right",
            timeout  = 3,
            screen   = awful.screen.focused()
        }
    end)
end

fanwibox:connect_signal("mouse::enter", show_fan_status)

fanwibox:connect_signal("mouse::leave", function()
    if notification then naughty.destroy(notification) end
end)

return fanwibox
