local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end

	c.shape = function(cr, w, h)
	  gears.shape.rounded_rect(cr, w, h, 8)
	end

end)

client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	-- c.border_color = beautiful.border_focus
  c.opacity = 1.0
end)

client.connect_signal("unfocus", function(c)
	-- c.border_color = beautiful.border_normal
  c.opacity = 0.9
end)
