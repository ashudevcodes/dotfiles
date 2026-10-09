-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XDG_CONFIG_HOME", os.getenv("HOME") .. "/.config")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GTK_A11Y", "none")
hl.env("GSK_RENDERER" ,"cairo")

