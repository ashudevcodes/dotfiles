pcall(require, "luarocks.loader")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("awful.remote")

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
