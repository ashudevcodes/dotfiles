local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

beautiful.init(gears.filesystem.get_themes_dir() .. "gtk/theme.lua")

beautiful.wallpaper                          = "/home/nemo/assets/portal_robot.png"
beautiful.font                               = "JetBrainsMonoNerdFontMono 10"

-- background
beautiful.bg_normal                          = "#1a1b26"
beautiful.bg_dark                            = "#090b0c"
beautiful.bg_focus                           = "#151821"
beautiful.bg_urgent                          = "#ed8274"
beautiful.bg_minimize                        = "#444444"

-- foreground
beautiful.fg_normal                          = "#c0caf5"
beautiful.fg_focus                           = "#e4e4e4"
beautiful.fg_urgent                          = "#ffffff"
beautiful.fg_minimize                        = "#ffffff"

-- wibar
beautiful.wibar_bg                           = "#1a1b26"
beautiful.wibar_border_width                 = 4
beautiful.wibar_fg                           = "#c0caf5"
beautiful.wibar_type                         = "desktop"
beautiful.wibar_height                       = dpi(30)
beautiful.wibar_ontop                        = false
beautiful.wibar_opacity                      = 0.9
beautiful.wibar_shape                        = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 12)
end

-- hotkey popus
beautiful.hotkeys_font                       = "JetBrainsMonoNerdFontMono 10"
beautiful.hotkeys_bg                         = "#1a1b26"
beautiful.hotkeys_fg                         = "#c0caf5"
beautiful.hotkeys_modifiers_fg               = beautiful.get().fg_urgent
beautiful.hotkeys_label_fg                   = "black"
beautiful.hotkeys_description_font           = "JetBrainsMonoNerdFontMono 10"

-- Borders
beautiful.border_normal                      = "#565f89"
beautiful.border_width                       = dpi(2)
beautiful.border_focus                       = "#bb9af7"
beautiful.border_marked                      = "#CC9393"

-- notification
naughty.config.defaults.margin               = 10
naughty.config.defaults.icon_size            = 64
naughty.config.defaults.position             = "top_right"
naughty.config.defaults.timeout              = 5
naughty.config.defaults.hover_timeout        = 0.5
naughty.config.defaults.font                 = "JetBrainsMonoNerdFontMono 10"
naughty.config.defaults.notification_opacity = 90
naughty.config.defaults.shape                = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 12)
end

beautiful.taglist_bg_focus                   = beautiful.border_normal
beautiful.taglist_bg_occupied                = beautiful.fg_normal
beautiful.taglist_bg_empty                   = beautiful.bg_normal
beautiful.taglist_fg_empty                   = beautiful.wibar_fg
