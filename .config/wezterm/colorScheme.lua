-- table which contain all theme of terminal
local color_scheme = {}

function color_scheme.apply_batman_theme(config)
	config.color_scheme = "Batman"
end

function color_scheme.apply_githubDark_theme(config)
	config.color_scheme = 'GitHub Dark'
end

function color_scheme.apply_tokyonight_theme(config)
	config.color_scheme = "Tokyo Night"
end

return color_scheme
