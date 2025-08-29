pcall(require, "luarocks.loader")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("awful.remote")
require("naughty")

require("./theme/custom_theme")
require("./veriable/globalVeriable")
require("./ui/wibarPanal")
require("./keybings/mouseAndKeyboardBings")
require("./rules/rules")
require("./signals/signals")
require("./programms/autoStartProgramms")

local gears = require("gears")
gears.timer({
	timeout = 30,
	autostart = true,
	callback = function()
		collectgarbage()
	end,
})
