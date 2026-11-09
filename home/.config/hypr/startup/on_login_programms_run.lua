-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  hl.exec_cmd("kitty --single-instance --start-as=hidden")
  hl.exec_cmd("hyprctl plugin load $HOME/.local/lib/hyprland/hyprGenie.so")
  hl.exec_cmd("awww-daemon & set_wallpaper.sh")
end)
