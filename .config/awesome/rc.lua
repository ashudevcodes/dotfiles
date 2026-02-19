pcall(require, "luarocks.loader")

------------------------------------------------------------
-- Core libraries (MUST be first)
------------------------------------------------------------
local gears     = require("gears")
local awful     = require("awful")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")
------------------------------------------------------------
-- Layout fix (important warning fix)
------------------------------------------------------------
awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
})

------------------------------------------------------------
-- Your modules
------------------------------------------------------------
require("./programms/autoStartProgramms")
require("./theme/custom_theme")
require("./veriable/globalVeriable")

local topbar = require("./ui/topbar")

------------------------------------------------------------
-- Screens
------------------------------------------------------------
awful.screen.connect_for_each_screen(function(s)
    topbar.create(s)
end)

------------------------------------------------------------
-- Keys / rules / signals
------------------------------------------------------------
require("./keybings/mouseAndKeyboardBings")
require("./rules/rules")
require("./signals/signals")
require("./wibgets/bluetooth")

------------------------------------------------------------
-- Periodic GC
------------------------------------------------------------
gears.timer({
    timeout   = 30,
    autostart = true,
    callback  = function()
        collectgarbage("collect")
    end,
})
