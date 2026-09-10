-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
--hl.gestures({ workspace_swipe_min_speed_to_force = true, })
hl.config({
	general = {
		gaps_out = 12,
		allow_tearing = false,

		border_size = 2,
		resize_on_border = true,
		col = {
			inactive_border = "rgb(39,39,39)",
			active_border = {
				angle = 90,
				colors = {
				  "rgb(68, 68, 68)",
				  "rgb(38,38,38)",
				},
			},
		},

	},

	gestures= {
	  workspace_swipe_min_speed_to_force = 200,
	  workspace_swipe_cancel_ratio = 0.1,
	},

	decoration = {
		rounding         = 17,
		rounding_power   = 4.0,

		active_opacity   = 1.0,
		inactive_opacity = 1.0,


		shadow = {
			enabled      = true,
			range        = 8,
			render_power = 2,
			color        = "rgba(00000044)",
		},

		blur = {
			enabled           = true,
			vibrancy          = 0.1696,
			new_optimizations = true,
			size              = 8,
			passes            = 4,
			--[[ noise             = 0.01,
			contrast          = 0.9,
			brightness        = 0.8, ]]
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.curve("sprint_for_workspace", { type = "spring", mass = 1, stiffness = 438.1191, dampening = 24.61279333 })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 423, dampening = 24.65 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

hl.animation({ leaf = "windows", enabled = true, speed = 0.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.1, spring = "easy", style = "gnomed" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })

hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 0.4, spring = "sprint_for_workspace" })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 0.1, spring = "sprint_for_workspace" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.1, spring = "sprint_for_workspace" })
