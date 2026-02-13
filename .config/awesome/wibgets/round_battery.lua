local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local cairo     = require("lgi").cairo

local unpack = table.unpack

-------------------------------------------------
-- Helpers
-------------------------------------------------

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local content = f:read("*all")
  f:close()
  return content
end

local function hex_to_rgb(hex)
  hex = (hex or "#ffffff"):gsub("#", "")
  return {
    tonumber(hex:sub(1,2),16)/255,
    tonumber(hex:sub(3,4),16)/255,
    tonumber(hex:sub(5,6),16)/255
  }
end

local colors = {
  outline  = hex_to_rgb(beautiful.fg_normal),
  fill     = hex_to_rgb(beautiful.fg_normal),
  charging = {0.3,0.85,0.4},
  low      = {1,0.6,0.2},
  critical = {1,0.3,0.3}
}

-------------------------------------------------
-- Widget Base
-------------------------------------------------

local battery = wibox.widget.base.make_widget()

battery.percentage        = 0
battery.display_pct       = 0
battery.is_charging       = false
battery.wave_phase        = 0
battery.interaction_force = 0
battery.low_notified      = false
battery.ripple_strength   = 0
battery.ripple_decay      = 0.92

-------------------------------------------------
-- Drawing
-------------------------------------------------

battery.draw = function(self, _, cr, width, height)

  cr:set_antialias(cairo.Antialias.GOOD)

  local b_w, b_h = 24, 12
  local nub_w, nub_h = 2, 4
  local radius = 4
  local pad = 2

  local total_w = b_w + nub_w + 1
  local x = (width - total_w)/2
  local y = (height - b_h)/2

  -- Outline
  cr:set_source_rgb(unpack(colors.outline))
  cr:set_line_width(1)
  cr:save()
  cr:translate(x,y)
  gears.shape.rounded_rect(cr,b_w,b_h,radius)
  cr:stroke()
  cr:restore()

  -- Nub
  cr:set_source_rgb(unpack(colors.outline))
  cr:save()
  cr:translate(x+b_w+1, y+(b_h-nub_h)/2)
  gears.shape.rounded_rect(cr,nub_w,nub_h,1)
  cr:fill()
  cr:restore()

  local fill_h = (b_h-pad*2) * (self.display_pct/100)

  if fill_h <= 0 then return end

  cr:save()
  cr:translate(x+pad, y+pad)

  local w = b_w-pad*2
  local h = b_h-pad*2

  gears.shape.rounded_rect(cr,w,h,3)
  cr:clip()

  -- Color
  if self.is_charging then
    cr:set_source_rgb(unpack(colors.charging))
  elseif self.percentage <= 10 then
    cr:set_source_rgb(unpack(colors.critical))
  elseif self.percentage <= 20 then
    cr:set_source_rgb(unpack(colors.low))
  else
    cr:set_source_rgb(unpack(colors.fill))
  end

  -- Wave amplitude
  local wave_amp = 0
  if self.is_charging then
    wave_amp = 1.5
  end
  wave_amp = wave_amp + (self.interaction_force * 2)
  wave_amp = wave_amp + (self.ripple_strength * 2)

  local phase = self.wave_phase

  cr:new_path()
  cr:move_to(0, h)

  for i = 0, w do
    local wave = math.sin((i/w)*math.pi*2 + phase)
    local y_offset = h - fill_h + wave * wave_amp
    cr:line_to(i, y_offset)
  end

  cr:line_to(w,h)
  cr:close_path()
  cr:fill()

  cr:restore()
end

battery.fit = function(_,_,_,height)
  return 30,height
end

-------------------------------------------------
-- Update
-------------------------------------------------

local function start_animation()
  if not battery.animation_timer.started then
    battery.animation_timer:start()
  end
end

function battery:update()

  local capacity = read_file("/sys/class/power_supply/BAT0/capacity")
  local status   = read_file("/sys/class/power_supply/BAT0/status")

  if capacity then
    local pct = tonumber(capacity)
    if pct and pct ~= self.percentage then
      if pct < self.percentage then
        self.ripple_strength = 1.0
      end
      self.percentage = pct
      start_animation()
    end
  end

  if status then
    local charging_now =
      status:match("Charging") or status:match("Full")

    if charging_now ~= self.is_charging then
      self.is_charging = charging_now
      start_animation()
    end
  end

  if self.percentage <= 20 and not self.low_notified then
    naughty.notify{title="Battery Low",text="Below 20%"}
    self.low_notified = true
  elseif self.percentage > 25 then
    self.low_notified = false
  end
end

-------------------------------------------------
-- Animation Timer (ZERO Idle Drain)
-------------------------------------------------

battery.animation_timer = gears.timer {
  timeout = 1/30,
  autostart = false,
  callback = function()

    battery.wave_phase = battery.wave_phase + 0.15

    battery.ripple_strength =
      battery.ripple_strength * battery.ripple_decay

    battery.display_pct =
      battery.display_pct +
      (battery.percentage - battery.display_pct) * 0.08

    battery.interaction_force =
      battery.interaction_force * 0.90

    if not battery.is_charging
      and battery.interaction_force < 0.01
      and battery.ripple_strength < 0.01
      and math.abs(battery.display_pct - battery.percentage) < 0.1 then

      battery.animation_timer:stop()
      return
    end

    battery:emit_signal("widget::redraw_needed")
  end
}

-------------------------------------------------
-- Polling
-------------------------------------------------

gears.timer {
  timeout = 10,
  autostart = true,
  callback = function()
    battery:update()
  end
}

battery:update()

-------------------------------------------------
-- Interaction
-------------------------------------------------

local notification

battery:connect_signal("mouse::enter", function()
  battery.interaction_force = 0.4
  start_animation()

  if notification then
    naughty.destroy(notification)
  end

  notification = naughty.notify {
    title = "Battery",
    text  = battery.percentage .. "%",
    timeout = 5,
    screen = awful.screen.focused()
  }
end)

battery:connect_signal("mouse::leave", function()
  if notification then
    naughty.destroy(notification)
  end
end)

battery:connect_signal("button::press", function()
  battery.interaction_force = 1.0
  start_animation()
end)

return battery
