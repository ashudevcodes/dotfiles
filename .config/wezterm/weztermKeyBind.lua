local wezterm = require("wezterm")

local module = {}

function module.spawn_new_tab(config)
	config.keys = {
		{
			key = "t",
			mods = "ALT",
			action = wezterm.action.SpawnTab("DefaultDomain"),
		},
	}
end

function module.switch_between_tabs(config)
	config.keys = config.keys or {}
	for i = 1, 8 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "ALT",
			action = wezterm.action.ActivateTab(i - 1),
		})
	end
end

return module
