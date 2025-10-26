local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

-- ACPI sample output:
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local HOME = os.getenv("HOME")
local WIDGET_DIR = HOME .. "/.config/awesome/widgets/"

local battery_widget = {}

local function worker(user_args)
	local args = user_args or {}

	local font = args.font or beautiful.font
	local path_to_icons = args.path_to_icons or HOME .. "/.local/icon/battery/"
	local show_current_level = args.show_current_level or false
	local margin_left = args.margin_left or 0
	local margin_right = args.margin_right or 0

	local display_notification = args.display_notification or false
	local display_notification_onClick = args.display_notification_onClick or true
	local position = args.notification_position or "top_right"
	local timeout = args.timeout or 10

	local warning_msg_title = args.warning_msg_title or "Battery warning"
	local warning_msg_text = args.warning_msg_text or "Battery level is low!"
	local warning_msg_position = args.warning_msg_position or "bottom_right"
	local warning_msg_icon = args.warning_msg_icon or WIDGET_DIR .. "spaceman.jpg"
	local enable_battery_warning = args.enable_battery_warning
	if enable_battery_warning == nil then
		enable_battery_warning = true
	end

	if not gfs.dir_readable(path_to_icons) then
		naughty.notify {
			title = "Battery Widget",
			text = "Icon folder not found: " .. path_to_icons,
			preset = naughty.config.presets.critical
		}
	end

	local icon_widget = wibox.widget {
		{
			id = "icon",
			widget = wibox.widget.imagebox,
			resize = false
		},
		valign = "center",
		layout = wibox.container.place
	}

	local level_widget = wibox.widget {
		font = font,
		widget = wibox.widget.textbox
	}

	battery_widget = wibox.widget {
		icon_widget,
		level_widget,
		layout = wibox.layout.fixed.horizontal
	}

	local notification
	local function show_battery_status()
		awful.spawn.easy_async("acpi", function(stdout)
			naughty.destroy(notification)
			notification = naughty.notify {
				text = stdout,
				title = "󱊣 Battery status",
				icon_size = dpi(16),
				position = position,
				timeout = 5,
				hover_timeout = 0.5,
				width = 200,
				screen = mouse.screen
			}
		end)
	end

	local function show_battery_warning()
		naughty.notify {
			icon = warning_msg_icon,
			icon_size = 100,
			text = warning_msg_text,
			title = warning_msg_title,
			timeout = 25,
			hover_timeout = 0.5,
			position = warning_msg_position,
			bg = "#F06060",
			fg = "#EEE9EF",
			width = 300,
			screen = mouse.screen
		}
	end

	local last_battery_check = os.time()

	watch("acpi -i", timeout, function(widget, stdout)
		local battery_info = {}
		local capacities = {}

		for s in stdout:gmatch("[^\r\n]+") do
			local status, charge_str = string.match(s, ".+: ([%a%s]+), (%d?%d?%d)%%")
			if status and charge_str then
				table.insert(battery_info, { status = status, charge = tonumber(charge_str) })
				table.insert(capacities, 0)
			end
			local cap_str = string.match(s, ".+last full capacity (%d+)")
			if cap_str ~= nil then
				capacities[#capacities] = tonumber(cap_str) or 0
			end
		end

		local total_capacity, total_charge, status = 0, 0, "Unknown"
		for i, batt in ipairs(battery_info) do
			if capacities[i] ~= nil then
				if batt.charge >= total_charge then
					status = batt.status
				end
				total_charge = total_charge + batt.charge * capacities[i]
				total_capacity = total_capacity + capacities[i]
			end
		end
		local charge = total_charge / total_capacity

		if show_current_level then
			level_widget.text = string.format(" %d%%", charge)
		else
			level_widget.text = ""
		end

		local icon_name = "battery-level-100-symbolic"

		local rounded = math.floor(charge / 10) * 10
		if rounded < 0 then rounded = 0 end
		if rounded > 100 then rounded = 100 end

		if status == "Charging" then
			icon_name = string.format("battery-level-%d-charging-symbolic", rounded)
		elseif status == "Full" then
			icon_name = "battery-level-100-charged-symbolic"
		elseif status == "Unknown" or status == "Not charging" then
			icon_name = string.format("battery-level-%d-plugged-in-symbolic", rounded)
		else
			icon_name = string.format("battery-level-%d-symbolic", rounded)
		end

		if enable_battery_warning and charge < 15 and status ~= "Charging" then
			if os.difftime(os.time(), last_battery_check) > 300 then
				last_battery_check = os.time()
				show_battery_warning()
			end
		end

		local icon_path = path_to_icons .. icon_name .. ".svg"
		widget.icon:set_image(icon_path)
	end, icon_widget)

	if display_notification then
		battery_widget:connect_signal("mouse::enter", function() show_battery_status("battery-level-100-symbolic") end)
		battery_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)
	elseif display_notification_onClick then
		battery_widget:connect_signal("button::press", function(_, _, _, button)
			if button == 1 then show_battery_status("battery-level-100-symbolic") end
		end)
		battery_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)
	end

	return wibox.container.margin(battery_widget, margin_left, margin_right)
end

return setmetatable(battery_widget, { __call = function(_, ...) return worker(...) end })
