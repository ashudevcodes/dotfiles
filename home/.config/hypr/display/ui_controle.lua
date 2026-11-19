package.loaded["~/.cache/wallust/generated/hypr"] = nil
local Colors = require("~/.cache/wallust/generated/hypr")
local C = Colors.hypr

hl.config({

 general = {
    gaps_out = 12,
    border_size = 2,
    resize_on_border = true,
    layout = "master",

    col = {
      active_border = {
        colors = { C.active_border, "rgba(00000011)", C.active_border },
        angle = 30,
      },
      inactive_border = {
        colors = { C.inactive_border, "rgba(00000011)", C.inactive_border },
        angle = 30,
      },
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
      offset = { 0, 4 },
      range = 30,
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
