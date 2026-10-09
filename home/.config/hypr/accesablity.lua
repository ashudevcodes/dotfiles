-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true,
		force_split = 2,

	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
		direction = "right",
		focus_fit_method = 0,
		column_width = 0.67,
	},
})

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
	match   = { class = ".*" },
	no_blur = true,

})

hl.window_rule({
	name = "scratchpad-float",
	match = { workspace = "special:magic" },
	float = true,
	size = { "monitor_w * 0.6", "monitor_h * 0.6" }
})

hl.window_rule({
	match = { class = "org.kde.dolphin", },
	float = true,
})

hl.window_rule({
	match = { title = "bluetooth_status", },
	float = true,
	size = { "monitor_w * 0.5", "monitor_h * 0.5" }
})

hl.window_rule({
	match = { title = "wifi_status", },
	float = true,
	size = { "monitor_w * 0.4", "monitor_h * 0.5" }
})
hl.window_rule({
	match = { class = "org.gnome.Nautilus", },
	float = true,
})

hl.window_rule({
	match = { class = "pcmanfm", },
	float = true,
})

hl.window_rule({
	match = { class = "org.pulseaudio.pavucontrol", },
	float = true,
})

hl.window_rule({
	match = { class = "mpv", },
	float = true,
})

hl.window_rule({
	match = { class = "kitty", },
	no_blur = false,
})

hl.window_rule({
	-- Ignore maximize requests from all apps.
	name           = "suppress-maximize-events",
	match          = { class = ".*" },

	suppress_event = "maximize",
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
	match = { namespace = ".*" },
	ignore_alpha = 0.01,
	blur = true,
	blur_popups = true
})

hl.layer_rule({
	match = { namespace = "pleamar" },
	blur = false,
	blur_popups = false,
})

hl.layer_rule({
	match     = {
		namespace = "rofi"
	},
	animation = "slidein",
})

hl.layer_rule({
	match      = {
		namespace = "notifications"
	},
	animation  = "slidein",
	above_lock = true
})

hl.layer_rule({
	match      = {
		namespace = "waybar"
	},
	animation  = "slidein",
	above_lock = true,
	xray       = true,

})

hl.layer_rule({
	match     = {
		namespace = "nybbletime"
	},
	animation = "popin",
	xray      = true
})
