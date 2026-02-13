local wibox    = require("wibox")
local cairo    = require("lgi").cairo
local animator = require("libs.animator")
local gears    = require("gears")

-------------------------------------------------
-- CONFIG
-------------------------------------------------

local size = 20

local color = {
    primary = {192/255, 202/255, 245/255},
    disable = {239/255, 68/255, 68/255},
}

-------------------------------------------------
-- ICON SETUP
-------------------------------------------------

local surface = cairo.ImageSurface(cairo.Format.ARGB32, size, size)
local cr = cairo.Context(surface)

local widget = wibox.widget.imagebox()
widget.resize = true

-------------------------------------------------
-- ANIMATION STATE
-------------------------------------------------

local progress    = 0
local target      = 0
local velocity    = 0
local tap_impulse = 0

-- Physics constants tuned for visible animation
local stiffness = 0.2
local damping   = 0.7

-------------------------------------------------
-- DRAW FUNCTION
-------------------------------------------------

local function draw_icon()
    cr:set_operator(cairo.Operator.CLEAR)
    cr:paint()
    cr:set_operator(cairo.Operator.OVER)

    local dim = 1 - (0.18 * progress) + (tap_impulse * 0.6)
    local r = color.primary[1] * dim
    local g = color.primary[2] * dim
    local b = color.primary[3] * dim

    local m = size * 0.12
    local w = size - 2 * m
    local h = size * 0.72
    local corner = 3
    local y_offset = (size - h) / 2
    local scale = 1 - 0.04 * progress + tap_impulse

    cr:save()
    cr:translate(size / 2, size / 2)
    cr:scale(scale, scale)
    cr:translate(-size / 2, -size / 2)

    -- background fill
    cr:set_source_rgba(r, g, b, 0.08)
    cr:rectangle(m, y_offset, w, h)
    cr:fill()

    -- shape outline
    cr:set_source_rgba(r, g, b, dim)
    cr:set_line_width(1.6)

    cr:move_to(m + corner, y_offset)
    cr:line_to(m + w - corner, y_offset)
    cr:arc(m + w - corner, y_offset + corner, corner, -math.pi/2, 0)
    cr:line_to(m + w, y_offset + h - corner)
    cr:arc(m + w - corner, y_offset + h - corner, corner, 0, math.pi/2)
    cr:line_to(m + corner, y_offset + h)
    cr:arc(m + corner, y_offset + h - corner, corner, math.pi/2, math.pi)
    cr:line_to(m, y_offset + corner)
    cr:arc(m + corner, y_offset + corner, corner, math.pi, 3*math.pi/2)
    cr:close_path()
    cr:stroke()

    -- divider lines
    local divider = y_offset + h * 0.72
    cr:move_to(m, divider)
    cr:line_to(m + w, divider)
    cr:stroke()

    cr:move_to(m + w / 2, divider)
    cr:line_to(m + w / 2, y_offset + h)
    cr:stroke()

    -- disabled circle
    if progress > 0.01 then
        cr:set_source_rgba(
            color.disable[1],
            color.disable[2],
            color.disable[3],
            progress
        )
        cr:arc(m + w - 2.5, y_offset + 2.5, 1.8, 0, 2 * math.pi)
        cr:fill()
    end

    cr:restore()
    widget.image = surface
end

draw_icon()

-------------------------------------------------
-- GLOBAL ANIMATION UPDATE
-------------------------------------------------

local function update_animation()
    local force = (target - progress) * stiffness
    velocity = (velocity + force) * damping
    progress = progress + velocity
    tap_impulse = tap_impulse * 0.85

    draw_icon()

    -- continue until small movement
    return not (
        math.abs(velocity) < 0.001 and 
        math.abs(target - progress) < 0.001 and 
        tap_impulse < 0.001
    )
end

local anim_obj = {}
function anim_obj:update()
    return update_animation()
end

-------------------------------------------------
-- STATE MANAGEMENT
-------------------------------------------------

local last_state

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    return content
end

local function update_state()
    local data = read_file("/tmp/touchpadState")
    local enabled = data and data:match("enabled")

    if enabled ~= last_state then
        last_state = enabled

        -- set animation target (0 or 1)
        target = enabled and 1 or 0

        -- bigger pop
        tap_impulse = 0.12

        -- subscribe to global animator
        animator.subscribe(anim_obj)
        animator.activate()
    end
end


-------------------------------------------------
-- RETURN MODULE
-------------------------------------------------

return {
    widget = widget,
    update = update_state
}
