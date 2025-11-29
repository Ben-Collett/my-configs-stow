local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9
wezterm.on("log_event", function(window, pane)
	wezterm.log_info("hello")
end)
--config.window_decorations = "NONE"
config.exit_behavior = "Close"
config.keys = {
	{ key = "1", mods = "CTRL", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "CTRL", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "CTRL", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "CTRL", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "CTRL", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "CTRL", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "CTRL", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "CTRL", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "CTRL", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "l", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
	{ key = "h", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
	{ key = "h", mods = "CTRL|ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "l", mods = "CTRL|ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "j", mods = "CTRL|ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "k", mods = "CTRL|ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "h", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
}
local cursor_color = "#A400D3"
local bg = "#000000"
config.colors = {
	background = bg,
	cursor_bg = cursor_color,
}
local colors = {
	"#FF0000", -- Red
	"#FF7F00", -- Orange
	"#FFFF00", -- Yellow
	"#00FF00", -- Green
	"#0000FF", -- Blue
	"#4B0082", -- Indigo
	"#9400D3", -- Violet
}

--local color_index = 1

--wezterm.on("update-right-status", function(window, _)
--	window:set_config_overrides({
--		colors = {
--			cursor_bg = colors[color_index],
--			cursor_fg = "#000000", -- You can adjust this as needed
--		},
--	})

-- Cycle through the colors
--	color_index = color_index % #colors + 1
--end)
return config
