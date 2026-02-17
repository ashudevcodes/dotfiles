local gears    = require("gears")
local wibox    = require("wibox")
local cairo    = require("lgi").cairo

local animator = require("libs.animator")
local physics  = require("libs.physics")
local power    = require("libs.power")

-------------------------------------------------
-- Config
-------------------------------------------------

local home = os.getenv("HOME")
local path_to_icons = home .. "/.local/icon/fan/"
local size = 32

local inertia     = 0.08
local damping     = 0.35
local torque_gain = 1.0

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

    cr:restore()

    fan_image:emit_signal("widget::redraw_needed")
end

-------------------------------------------------
-- Engine Update (Animator Driven)
-------------------------------------------------

function fan:update()

    local dt = 1 / power.get_fps()
    local active = false

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

    if active then
        draw()
    end

    return active
end

-------------------------------------------------
-- SIGNALS (ZERO POLLING)
-------------------------------------------------

-- Fan ON / OFF
awesome.connect_signal("fan::state", function(running)

    local new_target = running and 0.3 or 0

    if new_target ~= fan.target_speed then
        fan.target_speed = new_target
        animator.subscribe(fan)
        animator.activate()
    end
end)


-------------------------------------------------
-- Widget Container
-------------------------------------------------

local fanwibox = wibox.widget {
    fan_image,
    layout = wibox.layout.fixed.horizontal
}

-- Initial draw to show icon before any updates
draw()

return fanwibox
