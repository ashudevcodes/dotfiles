local beautiful = require("beautiful")
local gears = require("gears")

beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")

beautiful.get().wallpaper                = "/home/ashish/assets/portal_robot.png"
beautiful.get().font                     = "JetBrainsMonoNerdFontMono 10"

-- background
beautiful.get().bg_normal                = "#5b60711a"
beautiful.get().bg_dark                  = "#090b0c"
beautiful.get().bg_focus                 = "#151821"
beautiful.get().bg_urgent                = "#ed8274"
beautiful.get().bg_minimize              = "#444444"

-- foreground
beautiful.get().fg_normal                = "#ffffff"
beautiful.get().fg_focus                 = "#e4e4e4"
beautiful.get().fg_urgent                = "#ffffff"
beautiful.get().fg_minimize              = "#ffffff"

-- hotkey popus
beautiful.get().hotkeys_font             = "JetBrainsMonoNerdFontMono 10"
beautiful.get().hotkeys_bg               = "#1a1b26"
beautiful.get().hotkeys_fg               = "#c0caf5"
beautiful.get().hotkeys_modifiers_fg     = beautiful.get().fg_urgent
beautiful.get().hotkeys_label_fg         = "black"
beautiful.get().hotkeys_description_font = "JetBrainsMonoNerdFontMono 10"

-- Borders
beautiful.get().border_normal            = "#565f89cc"
beautiful.get().border_focus             = "#bb9af7ff"
beautiful.get().border_marked            = "#CC9393"
