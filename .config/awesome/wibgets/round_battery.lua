local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local cairo     = require("lgi").cairo
local animator  = require("libs.animator")

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

-------------------------------------------------
-- Colors
-------------------------------------------------

local colors = {
  outline  = hex_to_rgb(beautiful.fg_normal),
  fill     = hex_to_rgb(beautiful.fg_normal),
  charging = {0.3,0.85,0.4}, -- *same green as before*
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
battery.ripple_strength   = 0
battery.low_notified      = false

-- track AC/DC
battery.on_ac = nil

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

  -- Determine fill color
  if self.is_charging and self.percentage < 100 then
    cr:set_source_rgb(unpack(colors.charging))
  elseif self.is_charging then
  cr:set_source_rgb(unpack((colors.charging)))
  elseif self.percentage <= 10 then
    cr:set_source_rgb(unpack(colors.critical))
  elseif self.percentage <= 20 then
    cr:set_source_rgb(unpack(colors.low))
  else
    cr:set_source_rgb(unpack(colors.fill))
  end

  -- Wave amplitude logic
  local wave_amp = 0

  if self.is_charging and self.percentage < 100 then
    wave_amp = 1.5 -- wave while charging
  end

  wave_amp = wave_amp
           + (self.interaction_force * 2)
           + (self.ripple_strength * 2)

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
-- Animation Logic
-------------------------------------------------

local function animation_step()
  -- advance wave always
  battery.wave_phase = battery.wave_phase + 0.15

  -- interaction residue
  battery.interaction_force = battery.interaction_force * 0.90

  -- ripple fade
  battery.ripple_strength = battery.ripple_strength * 0.92

  -- smooth percentage
  battery.display_pct =
    battery.display_pct +
    (battery.percentage - battery.display_pct) * 0.08

  -- Should we keep animating?
  local active = false

  -- keep animating if charging & not full
  if battery.is_charging and battery.percentage < 100 then
    active = true
  end

  -- interaction + ripple
  if battery.interaction_force > 0.01
     or battery.ripple_strength > 0.01 then
    active = true
  end

  -- percent catching up
  if math.abs(battery.display_pct - battery.percentage) > 0.1 then
    active = true
  end

  if not active then
    return false
  end

  battery:emit_signal("widget::redraw_needed")
  return true
end

local anim_obj = {}
function anim_obj:update()
  return animation_step()
end

-------------------------------------------------
-- Update Logic
-------------------------------------------------

function battery:update()

  local capacity = read_file("/sys/class/power_supply/BAT0/capacity")
  local status   = read_file("/sys/class/power_supply/BAT0/status")
  local ac_online = read_file("/sys/class/power_supply/ACAD/online")

  if capacity then
    local pct = tonumber(capacity)
    if pct and pct ~= self.percentage then
      local dropping = pct < self.percentage
      if dropping then
        self.ripple_strength = self.ripple_strength + 1.0
      end
      self.percentage = pct
      animator.subscribe(anim_obj)
      animator.activate()
    end
  end

  if status then
    local charging_now =
      status:match("Charging") or status:match("Full")

    -- AC/DC change detection
    local on_ac = ac_online and tonumber(ac_online) == 1

    if on_ac ~= self.on_ac then
      self.on_ac = on_ac
      self.ripple_strength = self.ripple_strength + 1.2
      animator.subscribe(anim_obj)
      animator.activate()
    end

    if charging_now ~= self.is_charging then
      self.is_charging = charging_now
      animator.subscribe(anim_obj)
      animator.activate()
    end
  end

  -- low battery notification
  if self.percentage <= 20 and not self.low_notified then
    naughty.notify{title="Battery Low",text=self.percentage.."%"}
    self.low_notified = true
  elseif self.percentage > 25 then
    self.low_notified = false
  end
end

-------------------------------------------------
-- Polling
-------------------------------------------------

gears.timer {
  timeout = 4, -- check every 5s
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
  battery.interaction_force = battery.interaction_force + 0.6
  animator.subscribe(anim_obj)
  animator.activate()
end)

battery:connect_signal("mouse::leave", function()
  if notification then naughty.destroy(notification) end
end)

battery:connect_signal("button::press", function()
  battery.interaction_force = battery.interaction_force + 1.3
  animator.subscribe(anim_obj)
  animator.activate()

  if notification then naughty.destroy(notification) end
  notification = naughty.notify{
    title = "Battery",
    text  = battery.percentage.."%",
    timeout = 4,
    screen = awful.screen.focused()
  }
end)

return battery
