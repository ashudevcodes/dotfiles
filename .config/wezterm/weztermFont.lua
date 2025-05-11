local wezterm = require("wezterm")
local module = {}

function module.apply_jetbrainMonoFont(config)
	config.font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font",
		"Noto Sans CJK SC",
		"Symbols Nerd Font",
	})
end

return module
