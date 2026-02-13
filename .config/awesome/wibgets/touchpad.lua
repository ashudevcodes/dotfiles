local wibox = require("wibox")
local gears = require("gears")
local icons = require("libs.icons")

local touchpad_widget, update_icon = icons.create_touchpad_widget()

local touchPadWibox = wibox.widget {
    touchpad_widget,
    widget = wibox.container.margin,
}

-------------------------------------------------
-- Direct File Read
-------------------------------------------------

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    return content
end

-------------------------------------------------
-- State Tracking
-------------------------------------------------

local last_state = nil

local function check_touchpad_state()
    local out = read_file("/tmp/touchpadState")
    local disabled = out and out:match("disabled")

    if disabled ~= last_state then
        last_state = disabled
        update_icon(disabled)
    end
end

-- Initial check
check_touchpad_state()

-------------------------------------------------
-- Polling (Lightweight)
-------------------------------------------------

local state_timer = gears.timer {
    timeout   = 5,
    autostart = true,
    callback  = check_touchpad_state,
}

return touchPadWibox
