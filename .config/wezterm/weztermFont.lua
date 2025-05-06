local wezterm = require("wezterm")
local module = {}

function module.apply_jetbrainMonoFont(config)
	config.font = wezterm.font("JetBrains Mono")
end

return module
