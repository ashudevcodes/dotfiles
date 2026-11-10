require("utils")

require("env")

require("security.permissions")

require("input_devices.keyboard_shortcuts")
require("input_devices.touchpad_settings")
require("input_devices.keyboard_settings")


require("display.ui_controle")
require("display.ux_controle")
require("display.theme_color_change")
require("display.animation_controle")

require("layouts.dwindle")
require("layouts.scrolling")

require("startup.on_login_programms_run")

require("output_device.moniter_settings")

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
    swallow_exception_regex = "^(QEMU)$",
    vrr = 1,
    disable_autoreload = false,
  },
  cursor = {
    hide_on_key_press = true,
    warp_on_change_workspace = 1,
    inactive_timeout = 3,
  },
  binds = {
    hide_special_on_workspace_change = true,
  },
  render = {
    new_render_scheduling = true,
    -- use_shader_blur_blend  = true,
  },

  layers = {
    allow_new_top_layers_over_existing_fullscreen = true,
  },
})


hl.bind("switch:on:Lid Switch", function() hl.exec_cmd("hyprlock -q") end , { locked = true })

hl.bind("switch:off:Lid Switch", function() hl.exec_cmd("~/.local/bin/btConnect") end , { locked = true })
