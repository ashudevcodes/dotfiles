local awful    = require("awful")
local gears    = require("gears")
local wibox    = require("wibox")
local naughty  = require("naughty")
local cairo    = require("lgi").cairo

local animator = require("libs.animator")
local physics  = require("libs.physics")
local mathx    = require("libs.mathx")
local power    = require("libs.power")

-------------------------------------------------
-- Config
-------------------------------------------------

local home = os.getenv("HOME")
local path_to_icons = home .. "/.local/icon/fan/"
local command = home .. "/.local/bin/lappyFan state"

local size = 32

local inertia     = 0.08
local damping     = 0.35
local torque_gain = 1.0

-------------------------------------------------
-- Temperature
-------------------------------------------------

local function get_temp()
    local f = io.open("/sys/class/thermal/thermal_zone0/temp", "r")
    if not f then return 40 end
    local t = tonumber(f:read("*all"))
    f:close()
    return t and (t / 1000) or 40
end

-------------------------------------------------
-- Surface (REUSED)
-------------------------------------------------

local fan_surface = gears.surface.load_uncached(path_to_icons .. "fan.svg")
local rotating_surface = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
local cr = cairo.Context(rotating_surface)

local fan_image = wibox.widget {
    image  = rotating_surface,
    resize = true,
    widget = wibox.widget.imagebox,
}

-------------------------------------------------
-- State Object
-------------------------------------------------

local fan = {
    rotation      = 0,
    speed         = 0,
    target_speed  = 0,
    current_temp  = 40,
    display_temp  = 40,
}

-------------------------------------------------
-- Draw
-------------------------------------------------

local function draw()

    cr:set_operator(cairo.Operator.CLEAR)
    cr:paint()
    cr:set_operator(cairo.Operator.OVER)

    local w = fan_surface:get_width()
    local h = fan_surface:get_height()
    local scale = math.min(size / w, size / h)

    cr:save()
    cr:translate(size/2, size/2)
    cr:rotate(fan.rotation)
    cr:scale(scale, scale)
    cr:translate(-w/2, -h/2)

    cr:set_source_surface(fan_surface, 0, 0)
    cr:paint()

    -------------------------------------------------
    -- Thermal Overlay
    -------------------------------------------------

    local r, g, b = 1, 1, 1

    if fan.display_temp < 45 then
        r, g, b = 0.4, 0.7, 1     -- cool blue
    elseif fan.display_temp < 65 then
        r, g, b = 1, 1, 1         -- neutral
    elseif fan.display_temp < 80 then
        r, g, b = 1, 0.6, 0.2     -- warm
    else
        r, g, b = 1, 0.2, 0.2     -- hot
    end

    local intensity = math.min((fan.display_temp - 40) / 40, 1)

    cr:set_operator(cairo.Operator.ATOP)
    cr:set_source_rgba(r, g, b, 0.6 * intensity)
    cr:paint()
    cr:set_operator(cairo.Operator.OVER)

    cr:restore()

    fan_image:emit_signal("widget::redraw_needed")
end

-------------------------------------------------
-- Engine Update
-------------------------------------------------

function fan:update()

    local dt = 1 / power.get_fps()
    local active = false

    fan.display_temp =
        physics.smooth(fan.display_temp, fan.current_temp, 0.08)

    fan.speed =
        physics.motor(
            fan.speed,
            fan.target_speed,
            inertia,
            damping,
            torque_gain,
            dt
        )

    if math.abs(fan.speed) > 0.0001 then
        fan.rotation =
            (fan.rotation + fan.speed) % (2 * math.pi)
        active = true
    end

    if not mathx.near(fan.display_temp, fan.current_temp, 0.2) then
        active = true
    end

    if active then
        draw()
    end

    return active
end

-------------------------------------------------
-- Polling (AC/DC Aware)
-------------------------------------------------

local function update_state()

    -- On DC, we skip fan polling entirely (no shell call)
    if not power.is_on_ac() then
        fan.target_speed = 0
        fan.current_temp = get_temp()  -- optionally show thermal overlay
        animator.subscribe(fan)
        animator.activate()
        return
    end

    awful.spawn.easy_async_with_shell(command, function(out)

        if out and out:match("running") then
            fan.target_speed = 0.3
        else
            fan.target_speed = 0
        end

        animator.subscribe(fan)
        animator.activate()
    end)

    fan.current_temp = get_temp()
    animator.subscribe(fan)
    animator.activate()
end

gears.timer {
    timeout   = 5,
    autostart = true,
    callback  = update_state
}

update_state()

-------------------------------------------------
-- Premium Notification
-------------------------------------------------

local notification

local function show_fan_status()

    awful.spawn.easy_async_with_shell(command, function(stdout)

        local state_text

        if stdout and stdout:match("running") then
            state_text = "Cooling Active"
        else
            state_text = "Passive Cooling"
        end

        if notification then
            naughty.destroy(notification)
        end

        notification = naughty.notify {
            title    = "Thermal System",
            text     = state_text,
            icon     = path_to_icons .. "fan.svg",
            timeout  = 3,
            screen   = awful.screen.focused()
        }
    end)
end

fan_image:connect_signal("mouse::enter", show_fan_status)

fan_image:connect_signal("mouse::leave", function()
    if notification then
        naughty.destroy(notification)
    end
end)

-------------------------------------------------
-- Widget Container
-------------------------------------------------

local fanwibox = wibox.widget {
    fan_image,
    buttons = gears.table.join(
        awful.button({}, 1, function() awful.spawn(command) end)
    ),
    layout = wibox.layout.fixed.horizontal
}

return fanwibox
