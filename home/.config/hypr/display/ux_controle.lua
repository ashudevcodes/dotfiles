hl.config({
  binds = {
    drag_center_window = false,
  },

  general = {

    snap = {
      enabled = true,
      border_overlap = true,
      respect_gaps = true,
      monitor_gap = 10,
      window_gap = 10,
    },

  },
})


hl.window_rule({
  match   = { class = ".*" },
  no_blur = true,
})

hl.window_rule({
  match = { class = "mpv" },
  float = true,
  size = { "monitor_w * 0.8", "monitor_h * 0.8" },
  center = true,
  no_blur = true,
})

hl.window_rule({
  name = "scratchpad-float",
  match = { workspace = "special:minimized" },
  float = true,
  size = { "monitor_w * 0.6", "monitor_h * 0.6" },
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
  match = { title = "QEMU", },
  float = true,
})

hl.window_rule({
  match = { class = "org.localsend.localsend_app", },
  float = true,
})

hl.window_rule({
  match = { class = "org.pwmt.zathura", },
  float = true,
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
  match = { class = "kitty", },
  no_blur = false,
})

hl.window_rule({
  match = { class = "zen", },
  no_blur = true,
})

hl.window_rule({
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

hl.window_rule({
  name = "picture-in-picture",
  match = {
    class = "brave-browser",
    initial_title = "^Picture in picture$",
  },
  float = true,
  pin = true,
  size = "480 270",
  move = {
    "monitor_w-480-24",
    "monitor_h-270-24",
  },
})

hl.window_rule({
  -- Ignore maximize requests from all apps.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})



hl.layer_rule({
  match = { namespace = ".*" },
  ignore_alpha = 0.001,
  blur = true,
  blur_popups = true
})

hl.layer_rule({
  match     = {
    namespace = "rofi"
  },
  animation = "popin",
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.35,
})

hl.layer_rule({
  match     = {
    namespace = "awww-daemon"
  },
  animation = "disable",
  ignore_alpha = 0,
  blur = false,
  blur_popups = false,
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
    namespace = "bottom_bar"
  },
  animation  = "slidein",
  xray       = true,

})

hl.layer_rule({
  match     = {
    namespace = "nybbletime"
  },
  animation = "popin",
  xray      = true
})


hl.on("window.urgent", function(win)
  if not win then
    return
  end

  local workspace = win.workspace
  local active_workspace = hl.get_active_workspace()
  if workspace and active_workspace and workspace.id ~= active_workspace.id then
    hl.dispatch(hl.dsp.exec_cmd(notify_Send("Urgent: workspace " .. workspace.id .. "", win.title, "computer", "low")))
  end
end)
