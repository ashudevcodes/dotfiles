local color_scheme = require("colorScheme")
local font = require("weztermFont")

local config = {}

color_scheme.apply_tokyonight_theme(config)
font.apply_jetbrainMonoFont(config)

--  Add Some transparent on terminal
config.window_background_opacity = 0.9

-- remove Top Title Bar
config.enable_tab_bar = false

config.window_padding = {
	left = 10,
	right = 0,
	top = 10,
	bottom = 0,
}

config.font_size = 11
config.default_cwd = "/home/ashish/code/"

print(config)
return config
