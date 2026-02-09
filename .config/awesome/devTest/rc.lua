pcall(require, "luarocks.loader")

require("awful.autofocus")
require("mouseflow")
require("awful.hotkeys_popup.keys")
require("awful.remote")
require("naughty")

require("./programms/autoStartProgramms")
require("./theme/custom_theme")
require("./veriable/globalVeriable")
require("./ui/wibarPanal")
require("./keybings/mouseAndKeyboardBings")
require("./rules/rules")
require("./signals/signals")
-- require("./floatingWidgets/date")  -- Disabled for cleaner UI

local gears = require("gears")
gears.timer({
	timeout = 30,
	autostart = true,
	callback = function()
		collectgarbage()
	end,
})
