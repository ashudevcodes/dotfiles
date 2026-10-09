-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("kitty --single-instance --start-as=hidden")
	hl.exec_cmd("waybar -c ~/.config/waybar/bottomBar.jsonc -s ~/.config/waybar/bottom_bar.css")
	hl.exec_cmd("wlsunset -S 07:00 -s 22:00 -t 3500 -T 6500 -d 1800")
	hl.exec_cmd("awww-daemon & set_wallpaper.sh")
end)
