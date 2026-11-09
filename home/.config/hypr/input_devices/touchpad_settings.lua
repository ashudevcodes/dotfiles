hl.config({
  input = {
    follow_mouse = 0,

    sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.
    accel_profile = "adaptive",

    touchpad     = {
      natural_scroll = true,
      disable_while_typing = true,
      scroll_factor = 0.4,
    },
  },

  gestures = {
    workspace_swipe_cancel_ratio = 0,
    workspace_swipe_forever = true,
    workspace_swipe_direction_lock = true,
    workspace_swipe_direction_lock_threshold = 10,
  },
})
