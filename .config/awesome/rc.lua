pcall(require, "luarocks.loader")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("awful.remote")
require("naughty")

-- Create Custom theme
require("./theme/custom_theme")

-- Glodal Veriable default terminal set and kind of stuff
require("./veriable/globalVeriable")

-- Top Panel UI
require("./ui/wibarPanal")

--  Key bind for mouse and keyboard
require("./keybings/mouseAndKeyboardBings")
--
require("./rules/rules")
--
require("./signals/signals")

-- Startup Programs
require("./programms/autoStartProgramms")

-- Enable for lower memory consumption
local gears = require("gears")
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage("collect")
	end,
})
