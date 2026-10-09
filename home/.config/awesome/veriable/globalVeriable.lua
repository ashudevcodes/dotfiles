local awful = require("awful")

terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
awful.layout.layouts = {
	awful.layout.suit.tile,
}
