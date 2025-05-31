local awful = require("awful")
local beautiful = require("beautiful")

beautiful.init("~/dotfiles/.config/awesome/zenburn/theme.lua")

terminal = "wezterm"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.spiral.dwindle,
}
-- }}}
