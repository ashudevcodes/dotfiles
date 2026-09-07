-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
		direction = "right",
		focus_fit_method = 0,
	},
})

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.workspace_rule({
	workspace = "1",
	layout = "scrolling"
})

hl.window_rule({
    name = "scratchpad-float",
    match = { workspace = "special:magic" },
    float = true,
	size = {"monitor_w * 0.6", "monitor_h * 0.6"}
})

hl.window_rule({
	-- Ignore maximize requests from all apps.
	name           = "suppress-maximize-events",
	match          = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	match   = { class = ".*" },
	no_blur = true

})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name     = "fix-xwayland-drags",
	match    = {
		class      = "^$",
		title      = "^$",
		xwayland   = true,
		float      = true,
		fullscreen = false,
		pin        = false,
	},

	no_focus = true,
})


hl.layer_rule({
	match     = {
		namespace = "rofi"
	},
	blur      = true,
	animation = "slide",
	ignore_alpha = 0.01,
})

hl.layer_rule({
	match     = {
		namespace = "notifications"
	},
	blur      = true,
	ignore_alpha = 0.01,
	animation = "popin",
	above_lock = true
})

hl.layer_rule({
	match        = {
		namespace = "waybar"
	},
	blur         = true,
	blur_popups  = true,
	ignore_alpha = 0.01,
	xray         = true,
	above_lock = true
})

hl.layer_rule({
	match        = {
		namespace = "nybbletime"
	},
	blur         = true,
	ignore_alpha = 0.01,
	xray         = true
})
