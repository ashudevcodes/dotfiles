-- libs/icons.lua
local cairo = require("lgi").cairo
local gears = require("gears")
local wibox = require("wibox")

local icons = {}

local color = {
  primary = {192/255, 202/255, 245/255},
  disable = {239/255, 68/255, 68/255},
}

-------------------------------------------------
-- Touchpad Animated Widget (Spring Physics)
-------------------------------------------------

function icons.create_touchpad_widget()

  local size = 20
  local surface = cairo.ImageSurface(cairo.Format.ARGB32, size, size)
  local cr = cairo.Context(surface)

  local widget = wibox.widget.imagebox()
  widget.resize = true

  -------------------------------------------------
  -- Physics State
  -------------------------------------------------

  local tap_impulse = 0
  local progress = 0
  local target = 0
  local velocity = 0

  local stiffness = 0.18
  local damping = 0.75

  -------------------------------------------------
  -- Draw Function (Reuses Surface)
  -------------------------------------------------

  local function draw_frame()

	-- Clear surface
	cr:set_operator(cairo.Operator.CLEAR)
	cr:paint()
	cr:set_operator(cairo.Operator.OVER)

	local dim = 1 - (0.18 * progress) + (tap_impulse * 0.6)

	local r = color.primary[1] * dim
	local g = color.primary[2] * dim
	local b = color.primary[3] * dim

	local m = size * 0.12
	local w = size - 2*m
	local h = size * 0.72
	local corner = 3
	local y_offset = (size - h) / 2
	local scale = 1 - 0.04 * progress + tap_impulse

	cr:save()

	-- Slight shrink when disabled
	cr:translate(size/2, size/2)
	cr:scale(scale, scale)
	cr:translate(-size/2, -size/2)

	-- Soft inner fill
	cr:set_source_rgba(r, g, b, 0.08)
	cr:rectangle(m, y_offset, w, h)
	cr:fill()

	-- Border
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

	-- Divider lines
	local divider = y_offset + h * 0.72
	cr:move_to(m, divider)
	cr:line_to(m + w, divider)
	cr:stroke()

	cr:move_to(m + w/2, divider)
	cr:line_to(m + w/2, y_offset + h)
	cr:stroke()

	-- Red status dot
	if progress > 0.01 then
	  cr:set_source_rgba(
		color.disable[1],
		color.disable[2],
		color.disable[3],
		progress
	  )
	  cr:arc(m + w - 2.5, y_offset + 2.5, 1.8, 0, 2*math.pi)
	  cr:fill()
	end

	cr:restore()

	widget.image = surface
  end

  -------------------------------------------------
  -- Animation Loop (Spring Physics)
  -------------------------------------------------

  gears.timer {
	timeout = 0.016,
	autostart = true,
	callback = function()

	  -- Spring physics for enable/disable
	  local force = (target - progress) * stiffness
	  velocity = velocity + force
	  velocity = velocity * damping
	  progress = progress + velocity

	  -- Small tap impulse decay (for toggle feedback)
	  tap_impulse = tap_impulse * 0.85

	  if math.abs(velocity) < 0.001 and math.abs(target - progress) < 0.001 then
		progress = target
		velocity = 0
	  end

	  draw_frame()
	end
  }

  -------------------------------------------------
  -- Public Update Function
  -------------------------------------------------

  local function update(state)
	target = state and 1 or 0
	tap_impulse = 0.02
  end

  draw_frame()

  return widget, update
end

return icons
