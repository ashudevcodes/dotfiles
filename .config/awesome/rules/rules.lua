local awful = require("awful")
local beautiful = require("beautiful")

awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },

	{
		rule = { class = "zen" },
		properties = { floating = false, maximized = false },
	},
	{
		rule = { class = "XTerm" },
		properties = { size_hints_honor = false }
	},
	{
		rule = { class = "Inkscape" },
		properties = { floating = false, maximized = false },
	},

	{
		rule = { class = "Polybar" },
		properties = { border_width = 0, type = "dock" },
	},

	{
		rule_any = { type = { "dialog" }, role = { "pop-up" } },
		properties = { floating = true },
		callback = function(c)
			awful.placement.centered(c, nil)
		end,
	},
}
