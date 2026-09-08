-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("wlsunset -S 07:00 -s 18:00 -t 3500 -T 6500 -d 1800")
	hl.exec_cmd("waybar -c ~/.config/waybar/config-vertical.jsonc -s ~/.config/waybar/style-vertical.css")
	hl.exec_cmd("~/.local/bin/nybbletime")
	hl.exec_cmd("foot --server")
	hl.exec_cmd("~/.local/bin/set_wallpaper.sh")
	hl.exec_cmd("awww-daemon")
end)
