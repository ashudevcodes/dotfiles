-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- https://wiki.hypr.land/Configuring/Start/

require("env")
require("permissions")

require("accesablity")
require("display_Settings")
require("user_Interface")

require("shortcut_Keys")
require("input_Device_settings")

require("startup_Programmes")

hl.config({
	xwayland = {
		enabled = false,
	}
})

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		render_unfocused_fps = 1,
		lockdead_screen_delay = 0,
		enable_swallow = true,
		swallow_regex = "^(foot|kitty)$",
	},
	cursor = {
		hide_on_key_press = true,
		warp_on_change_workspace = 1,
	},
	binds = {
		hide_special_on_workspace_change = true,
	},
	render = {
		new_render_scheduling = false,
	},
})


hl.bind("switch:on:Lid Switch", function() hl.exec_cmd("hyprlock -q") end, { locked = true })
