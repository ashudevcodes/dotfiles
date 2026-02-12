local wibox = require("wibox")
local gears = require("gears")
local icons = require("libs.icons")

local touchpad_widget, update_icon = icons.create_touchpad_widget()

local touchPadWibox = wibox.widget {
    touchpad_widget,
    widget = wibox.container.margin,
}

-------------------------------------------------
-- Direct File Read (No Shell)
-------------------------------------------------

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    return content
end

local function check_touchpad_state()
    local out = read_file("/tmp/touchpadState")
    if out and out:match("disabled") then
        update_icon(true)
    else
        update_icon(false)
    end
end

check_touchpad_state()

gears.timer {
    timeout = 3,
    autostart = true,
    callback = check_touchpad_state,
}

return touchPadWibox
