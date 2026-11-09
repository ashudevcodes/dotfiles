local WINDOW_OPEN_SPEED = 2.0
local WINDOW_MOVE_SPEED = 2.4

local LAYER_OPEN_SPEED = 2.6
local LAYER_CLOSE_SPEED = 1.2

local LAYER_FADE_IN_SPEED = 1.5
local LAYER_FADE_OUT_SPEED = 1.0

local WORKSPACE_SWITCH_SPEED = 2.8

hl.config({ animations = { enabled = true, }, })

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 }, }, })
hl.curve("easeInQuint", { type = "bezier", points = { { 0.64, 0 }, { 0.78, 0 }, }, })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.42, 0 }, { 0.58, 1 }, }, })
hl.curve("windowMoveSpring", { type = "spring", mass = 1, stiffness = 300, damping = 27.7, })
hl.curve("LiquidBloomSpring", { type = "spring", mass = 1, stiffness = 220, damping = 20.5, })



hl.animation({
  leaf = "windows",
  enabled = true,
  speed = WINDOW_OPEN_SPEED,
  bezier = "easeOutQuint",
  style = "popin 96%",
})

hl.animation({
  leaf = "windowsIn",
  enabled = false,
})

hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = WINDOW_OPEN_SPEED,
  bezier = "easeOutQuint",
  style = "slide",
})

hl.animation({
  leaf = "windowsMove",
  enabled = true,
  speed = WINDOW_MOVE_SPEED,
  spring = "windowMoveSpring",
})



hl.animation({
  leaf = "layers",
  enabled = true,
  speed = LAYER_OPEN_SPEED,
  spring = "LiquidBloomSpring",
  style = "slide",
})

hl.animation({
  leaf = "layersIn",
  enabled = true,
  speed = LAYER_OPEN_SPEED,
  spring = "LiquidBloomSpring",
  style = "slide",
})

hl.animation({
  leaf = "layersOut",
  enabled = true,
  speed = LAYER_CLOSE_SPEED,
  bezier = "easeInQuint",
  style = "slide",
})



hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = WORKSPACE_SWITCH_SPEED,
  bezier = "easeInOutCubic",
})

hl.animation({
  leaf = "workspacesIn",
  enabled = true,
  speed = WORKSPACE_SWITCH_SPEED,
  spring = "windowMoveSpring",
  style = "slide",
})

hl.animation({
  leaf = "workspacesOut",
  enabled = true,
  speed = WORKSPACE_SWITCH_SPEED,
  spring = "windowMoveSpring",
  style = "slide",
})



hl.animation({ leaf = "fade", enabled = false })
hl.animation({ leaf = "fadeIn", enabled = false })
hl.animation({ leaf = "fadeOut", enabled = false })
hl.animation({ leaf = "fadeSwitch", enabled = false })
hl.animation({ leaf = "fadeShadow", enabled = false })
hl.animation({ leaf = "fadeGlow", enabled = false })
hl.animation({ leaf = "fadeDim", enabled = false })

hl.animation({ leaf = "fadePopups", enabled = false })
hl.animation({ leaf = "fadePopupsIn", enabled = false })
hl.animation({ leaf = "fadePopupsOut", enabled = false })

hl.animation({
  leaf = "fadeLayers",
  enabled = true,
  speed = LAYER_FADE_IN_SPEED,
  bezier = "easeOutQuint",
})

hl.animation({
  leaf = "fadeLayersIn",
  enabled = true,
  speed = LAYER_FADE_IN_SPEED,
  bezier = "easeOutQuint",
})

hl.animation({
  leaf = "fadeLayersOut",
  enabled = true,
  speed = LAYER_FADE_OUT_SPEED,
  bezier = "easeInQuint",
})
