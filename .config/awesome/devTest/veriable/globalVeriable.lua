local awful = require("awful")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

-- Use append_default_layouts to avoid the warning
awful.layout.append_default_layouts({
	awful.layout.suit.spiral,
})
