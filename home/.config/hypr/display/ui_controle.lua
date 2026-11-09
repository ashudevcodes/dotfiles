local Colors = require("display.theme_color_change")

hl.config({

  general ={
    gaps_out = 12,
    border_size = 0,
    resize_on_border = true,

    col = {
      active_border = Colors.window.active_border,
      inactive_border = Colors.window.inactive_border,
    },
  },

  decoration = {

    -- border edge roundness controle
    rounding = 10,
    rounding_power = 2,

    -- around borders glowness controle
    glow = {
      enabled = true,
      color = Colors.window.active_glow,
      color_inactive = Colors.window.inactive_glow,
      range = 10,
      render_power = 3,
    },

    shadow = {
      enabled = true,
      color = Colors.window.active_shadow,
      color_inactive = Colors.window.inactive_shadow,
      offset = { 0, 2 },
      range = 20,
    },

    blur = {
      enabled = true,
      size = 4,
      passes = 2,
      new_optimizations = true,
      xray = false,
      contrast = 1.0,
      brightness = 0.75,
      noise = 0.01,
      vibrancy = 0.35,
      vibrancy_darkness = 0.35,
      popups = true,
      special = true,
    },

  },
})
