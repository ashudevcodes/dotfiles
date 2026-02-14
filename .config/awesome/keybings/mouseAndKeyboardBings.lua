local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local naughty = require("naughty")
local touchpad = require("../wibgets/touchpad")

local launch_browser = function()
	awful.spawn("zen-browser")
end
local launch_gnome_file = function()
	awful.spawn("nemo")
end
local launch_rofi = function()
	awful.spawn("rofi -show drun -font 'jetbrainsmono 11'")
end

local touch_pad = function()
  awful.spawn.easy_async_with_shell(
	"~/.config/awesome/scripts/disable-touchpad.sh",
	function()
	  touchpad.update()
	end
  )
end

local toggleTopBar = function()
	local myscreen = awful.screen.focused()
	myscreen.topbar.visible = not myscreen.topbar.visible
  
end

local lappyPowerOff = function()
	awful.spawn.with_shell("systemctl poweroff")
end

local dpms_enabled = true

myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual",      terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart",     awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

mymainmenu = awful.menu({
	items = {
		{ "awesome",       myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
	},
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

menubar.utils.terminal = terminal

root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

globalkeys = gears.table.join(
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.with_shell("~/.config/awesome/scripts/volume.sh raise")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.with_shell("~/.config/awesome/scripts/volume.sh lower")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn.with_shell("~/.config/awesome/scripts/volume.sh toggle_mute")
	end),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn.with_shell("brightnessctl set +1%")
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn.with_shell("brightnessctl set 1%-")
	end),

	awful.key({ modkey, "Control" }, "p", lappyPowerOff, { description = "shutdown the computer", group = "system" }),
	awful.key({ modkey }, "w", toggleTopBar, { description = "toggle statusbar" }),

	-- Change focus by direction
	awful.key({ modkey }, "h", function()
		awful.client.focus.bydirection("left")
	end),
	awful.key({ modkey }, "j", function()
		awful.client.focus.bydirection("down")
	end),
	awful.key({ modkey }, "k", function()
		awful.client.focus.bydirection("up")
	end),
	awful.key({ modkey }, "l", function()
		awful.client.focus.bydirection("right")
	end),

  -- Resize windows 
  awful.key({ modkey, "Ctrl" }, "l", function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey, "Ctrl" }, "h",  function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Ctrl" }, "k",    function () awful.client.incwfact( 0.05)  end),
  awful.key({ modkey, "Ctrl" }, "j",  function () awful.client.incwfact(-0.05)  end),

  -- Layout manipulation
	awful.key({ modkey, "Shift" }, "h", function()
		awful.client.swap.bydirection("left")
	end, { description = "swap with left client", group = "client" }),
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.bydirection("down")
	end, { description = "swap with down client", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.bydirection("up")
	end, { description = "swap with up client", group = "client" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.client.swap.bydirection("right")
	end, { description = "swap with right client", group = "client" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "F1", function()
		if dpms_enabled then
			awful.spawn("xset s off -dpms")
			dpms_enabled = false
			naughty.notify({ text = "Screen timeout disabled" })
		else
			awful.spawn("xset s on +dpms")
			dpms_enabled = true
			naughty.notify({ text = "Screen timeout enabled" })
		end
	end, { description = "toggle screen timeout", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	awful.key({ modkey }, "Return", function()
	awful.spawn("xterm")
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "Return", function()
	awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "flameshot gui", group = "awesome" }),
	awful.key({ modkey }, "b", launch_browser, { description = "open a browser", group = "client" }),
	awful.key({ modkey }, "m", touch_pad, { description = "toggle TouchPad" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey }, "e", launch_gnome_file, { description = "open a GNOME Files", group = "client" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "r", launch_rofi, { description = "run app launcher", group = "launcher" })
)

clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
	c.fullscreen = not c.fullscreen
	c:raise()
	toggleTopBar()
  end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
