local wezterm = require("wezterm")
local fonts = {}

function fonts.apply_jetbrainMonoFont(config)
	config.font = wezterm.font_with_fallback({
		"JetBrainsMono Nerd Font"
	})
end

return fonts
