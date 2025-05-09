local wezterm = require("wezterm")

local module = {}

local function PrintAshuName()
	wezterm.log_error("Hello Ashu!", wezterm)
end

function module.apply_batman_theme(config)
	config.color_scheme = "Batman"
end

function module.apply_tokyonight_theme(config)
	-- PrintAshuName()
	config.color_scheme = "Tokyo Night"
end

return module
