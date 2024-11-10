local wezterm = require("wezterm")

local config = wezterm.config_builder()


config.window_background_opacity = 0.9

config.exit_behavior = "Close"


return config
