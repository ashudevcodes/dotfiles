local SPRINGS = {
  springMove  = { omega = 26, zeta = 0.95 },
  springOpen  = { omega = 22, zeta = 0.68 },
  springClose = { omega = 30, zeta = 1.00 },
  springLayer = { omega = 19, zeta = 0.72 },
}

for name, s in pairs(SPRINGS) do
  hl.curve(name, {
    type = "spring",
    mass = 1,
    stiffness = s.omega * s.omega,
    damping = 2 * s.zeta * s.omega,
  })
end

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })
hl.curve("easeInQuint",  { type = "bezier", points = { { 0.64, 0 }, { 0.78, 0 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.42, 0 }, { 0.58, 1 }, }, })
hl.curve("windowMoveSpring", { type = "spring", mass = 1, stiffness = 300, damping = 27.7, })

hl.config({ animations = { enabled = true } })

hl.animation({
  leaf = "windows",
  enabled = true,
  speed = 2.0,
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
  speed = 2.8,
  spring = "windowMoveSpring",
  style = "slide",
})

--[[ hl.animation({
  leaf = "windowsMove",
  enabled = true,
  speed = 2.4,
  spring = "windowMoveSpring",
}) ]]


hl.animation({ leaf = "layers",    enabled = true, speed = 1, spring = "springLayer", style = "slide" })
hl.animation({ leaf = "layersIn",  enabled = true, speed = 1, spring = "springLayer", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, spring = "springClose", style = "slide" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 2.8 , bezier = "easeInOutCubic" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.8, spring = "windowMoveSpring", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.8, spring = "windowMoveSpring", style = "slide" })

hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 1, spring = "springOpen",  style = "slidefadevert 20%" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1, spring = "springClose", style = "slidefadevert 20%" })

-- hl.animation({ leaf = "fadeIn",     enabled = true, speed = 2.2, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "fadeOut",    enabled = true, speed = 1.2, bezier = "easeInQuint" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 3,   bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeGlow",   enabled = true, speed = 3,   bezier = "easeOutQuint" })
hl.animation({ leaf = "border",     enabled = true, speed = 4,   bezier = "easeOutQuint" })

hl.animation({ leaf = "fadeLayers",    enabled = true, speed = 1.05, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.05, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.01, bezier = "easeInQuint" })

hl.animation({ leaf = "fade",       enabled = false })
hl.animation({ leaf = "fadeSwitch", enabled = false })
hl.animation({ leaf = "fadeDim",    enabled = false })
hl.animation({ leaf = "fadePopups",    enabled = false })
hl.animation({ leaf = "fadePopupsIn",  enabled = false })
hl.animation({ leaf = "fadePopupsOut", enabled = false })
