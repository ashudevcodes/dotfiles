local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local lgi       = require("lgi")
local cairo     = lgi.cairo
local Gio       = lgi.Gio
local animator  = require("libs.animator")

local unpack = table.unpack

-------------------------------------------------
-- Helpers
-------------------------------------------------

local function hex_to_rgb(hex)
  hex = (hex or "#ffffff"):gsub("#", "")
  return {
    tonumber(hex:sub(1,2),16)/255,
    tonumber(hex:sub(3,4),16)/255,
    tonumber(hex:sub(5,6),16)/255
  }
end

local function get_prop(proxy, name)
  local v = proxy:get_cached_property(name)
  if not v then return nil end
  return v.value
end

-------------------------------------------------
-- Colors
-------------------------------------------------

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
battery.ripple_strength   = 0
battery.low_notified      = false

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

  cr:set_source_rgb(unpack(colors.outline))
  cr:set_line_width(1.4)
  cr:save()
  cr:translate(x,y)
  gears.shape.rounded_rect(cr,b_w,b_h,radius)
  cr:stroke()
  cr:restore()

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

  if self.is_charging then
    cr:set_source_rgb(unpack(colors.charging))
  elseif self.percentage <= 10 then
    cr:set_source_rgb(unpack(colors.critical))
  elseif self.percentage <= 20 then
    cr:set_source_rgb(unpack(colors.low))
  else
    cr:set_source_rgb(unpack(colors.fill))
  end

  local wave_amp = 0

  if self.is_charging and self.percentage < 100 then
	-- convert percentage in to decimal
	-- invert decimal value base 0 or 100
	-- if battery percentage 0 -> 1.0 else if 100 -> 0.0
	-- then scale it in to max value
    wave_amp = 2 * (1 - self.percentage / 100)
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

  battery.wave_phase = battery.wave_phase + 0.15
  battery.interaction_force = battery.interaction_force * 0.90
  battery.ripple_strength   = battery.ripple_strength * 0.92

  battery.display_pct =
    battery.display_pct +
    (battery.percentage - battery.display_pct) * 0.08

  local active = false

  if battery.is_charging and battery.percentage < 100 then
    active = true
  end

  if battery.interaction_force > 0.01
     or battery.ripple_strength > 0.01 then
    active = true
  end

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
-- UPower DBus Integration
-------------------------------------------------

local function update_from_upower(proxy)

  local pct   = get_prop(proxy, "Percentage")
  local state = get_prop(proxy, "State")

  if pct and pct ~= battery.percentage then
    if pct < battery.percentage then
      battery.ripple_strength = battery.ripple_strength + 1.0
    end
    battery.percentage = pct
    animator.subscribe(anim_obj)
    animator.activate()
  end

  -- UPower state enum:
  -- 1 = charging
  -- 2 = discharging
  -- 4 = fully charged

  local charging_now = (state == 1 or state == 4)

  if charging_now ~= battery.is_charging then
    battery.is_charging = charging_now
	battery.ripple_strength = battery.ripple_strength + 1.2
	animator.subscribe(anim_obj)
	animator.activate()
  end


  if battery.percentage <= 20 and not battery.low_notified then
    naughty.notify{title="Battery " .. battery.percentage .."%".. " Low"}
    battery.low_notified = true
  elseif battery.percentage > 25 then
    battery.low_notified = false
  end
end

local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)

local battery_path = "/org/freedesktop/UPower/devices/battery_BAT0"

local proxy = Gio.DBusProxy.new_sync(
  bus,
  Gio.DBusProxyFlags.NONE,
  nil,
  "org.freedesktop.UPower",
  battery_path,
  "org.freedesktop.UPower.Device",
  nil
)


proxy:init(nil)

update_from_upower(proxy)

bus:signal_subscribe(
  "org.freedesktop.UPower",
  "org.freedesktop.DBus.Properties",
  "PropertiesChanged",
  battery_path,
  nil,
  Gio.DBusSignalFlags.NONE,
  function()
    update_from_upower(proxy)
  end
)

function getTimeToEmpty(proxy)
  local time = get_prop(proxy, "TimeToEmpty")

  if not time or time <= 0 then
    return "N/A"
  end

  local hours = math.floor(time / 3600)
  local mins = math.floor((time % 3600) / 60)

  if hours > 0 then
    return string.format("%dh:%dm", hours, mins)
  else
    return string.format("%dm", mins)
  end

end

function getEnergyRate(proxy)
  local eng_rate = get_prop(proxy,"EnergyRate")

  return eng_rate
end
-------------------------------------------------
-- Interaction
-------------------------------------------------

local notification

battery:connect_signal("mouse::enter", function()
  local w = mouse.current_wibox
  if w then
    w.cursor = "hand2"
  end
  battery.interaction_force = battery.interaction_force + 0.6
  animator.subscribe(anim_obj)
  animator.activate()
end)

battery:connect_signal("mouse::leave", function()
  local w = mouse.current_wibox
  if w then
    w.cursor = "left_ptr"
  end
  if notification then naughty.destroy(notification) end
end)

battery:connect_signal("button::press", function()
  local eng_rate = getEnergyRate(proxy)
  local time_to_empty = getTimeToEmpty(proxy)
  battery.interaction_force = battery.interaction_force + 1.3
  animator.subscribe(anim_obj)
  animator.activate()

  if notification then naughty.destroy(notification) end
  notification = naughty.notify{
	title = "Battery" .. ": " .. math.tointeger(battery.percentage).."%",
	text  = "Energy Rate: ".. eng_rate .. " W\nTime Remaining: " .. time_to_empty,
	timeout = 0,
	screen = awful.screen.focused()
  }
end)

return battery
