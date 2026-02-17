------------------------------------------------------------
-- Bluetooth Dashboard (Phase 1)
------------------------------------------------------------

local awful     = require("awful")
local wibox     = require("wibox")
local naughty   = require("naughty")
local lgi       = require("lgi")

local Gio = lgi.Gio

local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)

------------------------------------------------------------
-- Helpers
------------------------------------------------------------

local function get_codec_name(id)
    if id == 0 then return "SBC"
    elseif id == 2 then return "AAC"
    else return "Unknown"
    end
end

------------------------------------------------------------
-- Device Data Fetch
------------------------------------------------------------

local function create_device_widget(path)

    local device_proxy = Gio.DBusProxy.new_for_bus_sync(
        Gio.BusType.SYSTEM,
        Gio.DBusProxyFlags.NONE,
        nil,
        "org.bluez",
        path,
        "org.bluez.Device1",
        nil
    )

    local battery = "?"
    local codec   = "-"
    local stream  = "-"
    local name    = device_proxy.Name or "Unknown"

    -- Try battery
    pcall(function()
        local bat_proxy = Gio.DBusProxy.new_for_bus_sync(
            Gio.BusType.SYSTEM,
            Gio.DBusProxyFlags.NONE,
            nil,
            "org.bluez",
            path,
            "org.bluez.Battery1",
            nil
        )
        battery = bat_proxy.Percentage or "?"
    end)

    -- Try transport
    local transport_path = path .. "/fd0"
    pcall(function()
        local tr_proxy = Gio.DBusProxy.new_for_bus_sync(
            Gio.BusType.SYSTEM,
            Gio.DBusProxyFlags.NONE,
            nil,
            "org.bluez",
            transport_path,
            "org.bluez.MediaTransport1",
            nil
        )
        codec  = get_codec_name(tr_proxy.Codec)
        stream = tr_proxy.State
    end)

    --------------------------------------------------------
    -- UI
    --------------------------------------------------------

    local name_widget = wibox.widget.textbox(name)
    local info_widget = wibox.widget.textbox()

    local function refresh()
        local connected = device_proxy.Connected and "Connected" or "Disconnected"
        info_widget.text =
            "🔋 " .. tostring(battery) ..
            "%  |  " ..
            "🎵 " .. codec ..
            "  |  ▶ " .. stream ..
            "  |  " .. connected
    end

    refresh()

    -- Listen for changes
    device_proxy.on_g_properties_changed = function(_, changed)
        refresh()
    end

    local container = wibox.widget {
        {
            name_widget,
            info_widget,
            spacing = 4,
            layout  = wibox.layout.fixed.vertical
        },
        margins = 12,
        widget  = wibox.container.margin
    }

    return container
end

------------------------------------------------------------
-- Find Devices
------------------------------------------------------------

local function get_devices()

    local devices = {}

    local manager = Gio.DBusProxy.new_for_bus_sync(
        Gio.BusType.SYSTEM,
        Gio.DBusProxyFlags.NONE,
        nil,
        "org.bluez",
        "/",
        "org.freedesktop.DBus.ObjectManager",
        nil
    )

    local objects = manager:GetManagedObjects()

    for path, interfaces in pairs(objects) do
        if interfaces["org.bluez.Device1"] then
            table.insert(devices, path)
        end
    end

    return devices
end

------------------------------------------------------------
-- Build Dashboard
------------------------------------------------------------

local device_list = wibox.layout.fixed.vertical()

for _, path in ipairs(get_devices()) do
    device_list:add(create_device_widget(path))
end

local dashboard = awful.popup {
    widget = {
        {
            {
                text   = "Bluetooth Dashboard",
                widget = wibox.widget.textbox
            },
            device_list,
            spacing = 10,
            layout  = wibox.layout.fixed.vertical
        },
        margins = 20,
        widget  = wibox.container.margin
    },
    border_width = 2,
    border_color = "#5E81AC",
    ontop        = true,
    visible      = false,
    placement    = awful.placement.centered
}

------------------------------------------------------------
-- Toggle Function
------------------------------------------------------------

local function toggle_dashboard()
    dashboard.visible = not dashboard.visible
end

------------------------------------------------------------
return {
    toggle = toggle_dashboard
}
