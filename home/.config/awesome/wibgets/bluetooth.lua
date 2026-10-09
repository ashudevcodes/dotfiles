local naughty = require("naughty")
local lgi     = require("lgi")
local Gio     = lgi.Gio

local home = os.getenv("HOME")
local icon_filename = home .. "/.local/icon/earbuds/buds.png"

-------------------------------------------------
-- DBus Setup
-------------------------------------------------
local function get_prop(proxy, name)
  local v = proxy:get_cached_property(name)
  if not v then return nil end
  return v.value
end

local function update_from_bluez(proxy)
  local name      = get_prop(proxy, "Model")
  local battery   = get_prop(proxy, "Percentage")
  local warning   = get_prop(proxy, "WarningLevel")

  print(warning,name,battery)

  if name and battery then
	local text = "<b>" .. name .. "</b>\nBattery: " .. battery .. "%"

	naughty.notify {
	  icon    = icon_filename,
	  title   = connected and "Bluetooth Connected" or "Bluetooth Disconnected",
	  message = text,
	  timeout = 5
	}
  end
end


local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)

local buds = "/org/freedesktop/UPower/devices/headset_dev_0C_ED_C8_CB_BF_F3"

local proxy, err = Gio.DBusProxy.new_sync(
  bus,
  Gio.DBusProxyFlags.NONE,
  nil,
  "org.freedesktop.UPower",
  buds,
  "org.freedesktop.UPower.Device",
  nil,
  function ()
  	print("sucess")
  end
)

if err then
	print(err)
end

-- proxy:init(nil)

-- bus:signal_subscribe(
--   "org.freedesktop.UPower",
--   "org.freedesktop.DBus.Properties",
--   "PropertiesChanged",
--   buds,
--   nil,
--   Gio.DBusSignalFlags.NONE,
--   function()
-- 	update_from_bluez(proxy)
--   end
-- )
update_from_bluez(proxy)

proxy.g_properties_changed = function()
  update_from_bluez(proxy)
end

return {}
