local wezterm = require("wezterm")
local color_scheme = require("colorScheme")
local font = require("weztermFont")
local keybind = require("weztermKeyBind")

local config = wezterm.config_builder()

color_scheme.apply_tokyonight_theme(config)
font.apply_jetbrainMonoFont(config)

-- Switch Tabs and Create new one
keybind.spawn_new_tab(config)
keybind.switch_between_tabs(config)

--  Add Some transparent on terminal
config.window_background_opacity = 0.9

-- remove Top Title Bar
config.enable_tab_bar            = false

config.window_padding            = {
    left = 10,
    right = 0,
    top = 10,
    bottom = 0,
}

config.font_size                 = 11

config.set_environment_variables = {
    WEZTERM_SHELL_SKIP_ALL = "1",
}

config.audible_bell              = "Disabled"

return config
