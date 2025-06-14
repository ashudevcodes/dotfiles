local beautiful = require("beautiful")
local gears = require("gears")

beautiful.init(gears.filesystem.get_themes_dir() .. "gtk/theme.lua")

beautiful.wallpaper = "/home/ashish/assets/portal_robot.png"
beautiful.font = "JetBrainsMonoNerdFontMono 10"

-- background
beautiful.bg_normal = "#5b60711a"
beautiful.bg_dark = "#090b0c"
beautiful.bg_focus = "#151821"
beautiful.bg_urgent = "#ed8274"
beautiful.bg_minimize = "#444444"

-- foreground
beautiful.fg_normal = "#ffffff"
beautiful.fg_focus = "#e4e4e4"
beautiful.fg_urgent = "#ffffff"
beautiful.fg_minimize = "#ffffff"

-- hotkey popus
beautiful.hotkeys_font = "JetBrainsMonoNerdFontMono 10"
beautiful.hotkeys_bg = "#1a1b26"
beautiful.hotkeys_fg = "#c0caf5"
beautiful.hotkeys_modifiers_fg = beautiful.get().fg_urgent
beautiful.hotkeys_label_fg = "black"
beautiful.hotkeys_description_font = "JetBrainsMonoNerdFontMono 10"

-- Borders
beautiful.border_normal = "#565f89cc"
beautiful.border_focus = "#bb9af7ff"
beautiful.border_marked = "#CC9393"
