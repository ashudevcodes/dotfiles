local ANIMATION_SPEED = 4
local EXIT_ANIMATION_SPEED = 2.5
local LAYER_OUT_SPEED = 2
local WORKSPACES_SWITCH_ANIMATION_SPEED = 3.5
local FADE_ANIMATION_SPEED = 3

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_out = 12,
		allow_tearing = false,

		border_size = 0,
		resize_on_border = true,

		col = {
			inactive_border = "rgb(19,19,19)",
			active_border = "rgb(29, 29, 29)",
		},

	},
	gestures = {
		workspace_swipe_cancel_ratio = 0,
		workspace_swipe_forever = true,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
	},

	decoration = {
		rounding = 13,
		rounding_power = 8,
		active_opacity = 1.0,
		inactive_opacity = 1.0,


		shadow = {
			enabled = true,
			--color = "0xbf000009",
			color = "0xbf000000",
			offset = { 0, 2 },
			--scale = 0.9,
			range = 11,
			render_power = 3,
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
			contrast = 1.000000,
			enabled = true,
			input_methods = true,
			--input_methods_ignorealpha = 0.8,
			--ignore_opacity = true,
			new_optimizations = true,
			noise = 0.030000,
			passes = 4,
			size = 4,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("windowSpring", { type = "spring", mass = 10, stiffness = 6000, dampening = 270 })
hl.curve("layerSpring", { type = "spring", mass = 10, stiffness = 6000, dampening = 320 })

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })

hl.curve("joy", { type = "bezier", points = { { 0.34, 1.3 }, { 0.64, 1 } } })


hl.animation({ leaf = "windows", enabled = 1, speed = ANIMATION_SPEED, spring = "windowSpring", })
hl.animation({ leaf = "windowsIn", enabled = 1, speed = ANIMATION_SPEED, spring = "windowSpring", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = 1, speed = EXIT_ANIMATION_SPEED, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = 1, speed = ANIMATION_SPEED, spring = "windowSpring", })

hl.animation({ leaf = "layers", enabled = 1, speed = ANIMATION_SPEED, spring = "layerSpring", })
hl.animation({ leaf = "layersIn", enabled = 1, speed = ANIMATION_SPEED, spring = "layerSpring", style = "slide 90%" })
hl.animation({ leaf = "layersOut", enabled = 1, speed = LAYER_OUT_SPEED, bezier = "easeOutQuint", })

--[[ hl.animation({ leaf = "workspaces", enabled = 1, speed = animation_speed, spring = "default", })
hl.animation({ leaf = "workspacesIn", enabled = 1, speed = animation_speed, spring = "default", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = 1, speed = animation_speed, spring = "default", }) ]]


hl.animation({ leaf = "workspaces", enabled = 1, speed = WORKSPACES_SWITCH_ANIMATION_SPEED, bezier = "joy", })
hl.animation({
	leaf = "workspacesIn",
	enabled = 1,
	speed = WORKSPACES_SWITCH_ANIMATION_SPEED,
	bezier = "joy",
	style =
	"slide"
})
hl.animation({
	leaf = "workspacesOut",
	enabled = 1,
	speed = WORKSPACES_SWITCH_ANIMATION_SPEED,
	bezier = "joy",
	style =
	"slide"
})

hl.animation({ leaf = "fade", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeIn", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeOut", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeSwitch", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeShadow", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeGlow", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeDim", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })

hl.animation({ leaf = "fadePopups", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadePopupsIn", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadePopupsOut", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })

hl.animation({ leaf = "fadeLayers", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeLayersIn", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
hl.animation({ leaf = "fadeLayersOut", enabled = 0, speed = FADE_ANIMATION_SPEED, bezier = "default", })
