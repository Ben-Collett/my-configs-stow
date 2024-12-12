local wezterm = require("wezterm")

local config = wezterm.config_builder()


config.window_background_opacity = 0.9

config.exit_behavior = "Close"

config.keys = {
    { key = '1', mods = 'CTRL', action = wezterm.action{ActivateTab = 0} },
    { key = '2', mods = 'CTRL', action = wezterm.action{ActivateTab = 1} },
    { key = '3', mods = 'CTRL', action = wezterm.action{ActivateTab = 2} },
    { key = '4', mods = 'CTRL', action = wezterm.action{ActivateTab = 3} },
    { key = '5', mods = 'CTRL', action = wezterm.action{ActivateTab = 4} },
    { key = '6', mods = 'CTRL', action = wezterm.action{ActivateTab = 5} },
    { key = '7', mods = 'CTRL', action = wezterm.action{ActivateTab = 6} },
    { key = '8', mods = 'CTRL', action = wezterm.action{ActivateTab = 7} },
    { key = '9', mods = 'CTRL', action = wezterm.action{ActivateTab = 8} },
    {key = 't', mods = 'CTRL', action = wezterm.action{SpawnTab='CurrentPaneDomain'}},
    {key="l", mods="ALT", action=wezterm.action{ActivateTabRelative=1}},
    {key="h", mods="ALT", action=wezterm.action{ActivateTabRelative=-1}},
    {key="h", mods="CTRL|ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="l", mods="CTRL|ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="j", mods="CTRL|ALT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="k", mods="CTRL|ALT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="h", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Left"}},
    {key="j", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Down"}},
    {key="k", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Up"}},
    {key="l", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Right"}} 
   }
return config
