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

require("login_Startup_Programmes")

hl.config({
	xwayland = {
		enabled = false,
	}
})

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo   = true,
	},
})


hl.bind("switch:on:Lid Switch", function() hl.exec_cmd("hyprlock -q") end, { locked = true })
