local naughty = require("naughty")
local lgi     = require("lgi")
local Gio     = lgi.Gio

local home = os.getenv("HOME")
local icon_filename = home .. "/.local/icon/earbuds/buds.png"

-------------------------------------------------
-- DBus Setup
-------------------------------------------------

local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)

-- Bluetooth earbuds proxy
local buds_name = Gio.DBusProxy.new_sync(
  bus,
  Gio.DBusProxyFlags.NONE,
  nil,
  "org.bluez",
  "/org/bluez/hci0/dev_0C_ED_C8_CB_BF_F3",
  "org.bluez.Device1",
  nil
)
buds_name:init(nil)

local buds_battery = Gio.DBusProxy.new_sync(
  bus,
  Gio.DBusProxyFlags.NONE,
  nil,
  "org.bluez",
  "/org/bluez/hci0/dev_0C_ED_C8_CB_BF_F3",
  "org.bluez.Battery1",
  nil
)
buds_battery:init(nil)

-------------------------------------------------
-- Helper functions
-------------------------------------------------
local function buds_name_prop(name)
  local v = buds_name:get_cached_property(name)
  return v and v.value
end

local function buds_battery_prop(name)
  local v = buds_battery:get_cached_property(name)
  return v and v.value
end

local last_connected = nil

local function update_from_bluez()
  local name      = buds_name_prop("Name")
  local battery   = buds_battery_prop("Percentage")
  local connected = buds_name_prop("Connected")

  if name and battery then
    local text = "<b>" .. name .. "</b>\nBattery: " .. battery .. "%"

    if connected ~= last_connected then
      naughty.notify {
        icon    = icon_filename,
        title   = connected and "Bluetooth Connected" or "Bluetooth Disconnected",
        message = text,
        timeout = 5
      }
      last_connected = connected
    end
  end
end


-------------------------------------------------
-- Listen for Property Changes
-------------------------------------------------
buds_name.on_g_properties_changed = function()
  update_from_bluez()
end

return {}
