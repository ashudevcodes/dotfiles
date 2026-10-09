-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_out = 12,
		allow_tearing = false,

		border_size = 2,
		resize_on_border = true,

		col = {
			inactive_border = "rgb(29,29,29)",
			active_border = "rgb(69, 69, 69)",
		},

	},
	gestures = {
		workspace_swipe_cancel_ratio = 0,
		workspace_swipe_forever = true,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		--[[ workspace_swipe_distance = 700,
        workspace_swipe_cancel_ratio = 0.2,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_create_new = true ]]
	},

	decoration = {
		rounding = 13,
		rounding_power = 8,
		active_opacity = 1.0,
		inactive_opacity = 1.0,


		shadow = {
			enabled = true,
			color = "0xbf000009",
			offset = { 0, 24 },
			scale = 0.9,
			range = 124,
			--sharp = true,
		},

		blur = {
			--[[ enabled = true,
			new_optimizations = true,
			size = 30,
			passes = 3,
			noise = 0,
			vibrancy = 0.3,
			vibrancy_darkness = 0.8, ]]
			--[[ size = 10,
            passes = 3,
            brightness = 1,
            vibrancy = 0.5,
            vibrancy_darkness = 0.5,
            popups = true,
            popups_ignorealpha = 0.6,
            input_methods = true,
            input_methods_ignorealpha = 0.8,
			contrast=1.000000,
]]
			contrast=1.000000,
			enabled=1,
            input_methods = true,
            input_methods_ignorealpha = 0.8,
			ignore_opacity=1,
			new_optimizations=1,
			noise=0.030000,
			passes=4,
			size=4,
		},
	},

	animations = {
		enabled = true,
	},
})

local animation_speed = 0.1
local workspaces_switch_animation_speed = 6
local fade_animation_speed = 6

-- The more “stiffness”, the more speed, and the more “dampening”, the less bounce.

hl.curve("rubber", { type = "spring", mass = 10, stiffness = 3899, dampening = 275 })

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } });


hl.animation({ leaf = "windows", enabled = 1, speed = animation_speed, spring = "rubber", })
hl.animation({ leaf = "windowsIn", enabled = 1, speed = animation_speed, spring = "rubber", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = 1, speed = animation_speed, spring = "rubber", })

hl.animation({ leaf = "layers", enabled = 1, speed = animation_speed, spring = "rubber", })
hl.animation({ leaf = "layersIn", enabled = 1, speed = animation_speed, spring = "rubber", })
hl.animation({ leaf = "layersOut", enabled = 1, speed = animation_speed, spring = "rubber", })

--[[ hl.animation({ leaf = "workspaces", enabled = 1, speed = animation_speed, spring = "default", })
hl.animation({ leaf = "workspacesIn", enabled = 1, speed = animation_speed, spring = "default", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = 1, speed = animation_speed, spring = "default", }) ]]


hl.animation({ leaf = "workspaces", enabled = 1, speed = workspaces_switch_animation_speed, bezier = "easeOutQuint", })
hl.animation({
	leaf = "workspacesIn",
	enabled = 1,
	speed = workspaces_switch_animation_speed,
	bezier = "easeOutQuint",
	style =
	"slide"
})
hl.animation({
	leaf = "workspacesOut",
	enabled = 1,
	speed = workspaces_switch_animation_speed,
	bezier = "easeOutQuint",
	style =
	"slide"
})

hl.animation({ leaf = "fade", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeIn", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeOut", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeSwitch", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeShadow", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeGlow", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeDim", enabled = 0, speed = fade_animation_speed, bezier = "default", })

hl.animation({ leaf = "fadePopups", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadePopupsIn", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadePopupsOut", enabled = 0, speed = fade_animation_speed, bezier = "default", })

hl.animation({ leaf = "fadeLayers", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeLayersIn", enabled = 0, speed = fade_animation_speed, bezier = "default", })
hl.animation({ leaf = "fadeLayersOut", enabled = 0, speed = fade_animation_speed, bezier = "default", })
