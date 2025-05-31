local themes_path = require("gears.filesystem").get_themes_dir()
local dpi = require("beautiful.xresources").apply_dpi

-- Main
local theme = {}
theme.wallpaper = "~/assets/portal_rodot.png"


-- Styles
theme.font                     = "JetBrainsMonoNerdFontMono 10"

-- Colors
theme.bg_systray               = theme.bg_normal

-- Background
theme.bg_normal                = "#5B60711A"
theme.bg_dark                  = "#090B0C"
theme.bg_focus                 = "#151821"
theme.bg_urgent                = "#ed8274"
theme.bg_minimize              = "#444444"

-- Foreground
theme.fg_normal                = "#ffffff"
theme.fg_focus                 = "#e4e4e4"
theme.fg_urgent                = "#ffffff"
theme.fg_minimize              = "#ffffff"

-- Hotkey Popus
theme.hotkeys_font             = "JetBrainsMonoNerdFontMono"
theme.hotkeys_bg               = "#1f2335ff"
theme.hotkeys_fg               = "#c0caf5"
theme.hotkeys_modifiers_fg     = theme.fg_urgent
theme.hotkeys_label_fg         = "#24283b"
theme.hotkeys_description_font = "JetBrainsMonoNerdFontMono"

-- Borders
theme.useless_gap              = dpi(4)
theme.border_width             = dpi(1)
theme.border_normal            = "#565f89cc"
theme.border_focus             = "#bb9af7ff"
theme.border_marked            = "#CC9393"

-- Mouse finder
theme.mouse_finder_color       = "#CC9393"

-- Menu
theme.menu_height              = dpi(15)
theme.menu_width               = dpi(100)

-- Icons
-- Taglist
theme.taglist_squares_sel      = themes_path .. "zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel    = themes_path .. "zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"

-- Misc
theme.awesome_icon             = themes_path .. "zenburn/awesome-icon.png"
theme.menu_submenu_icon        = themes_path .. "default/submenu.png"


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
