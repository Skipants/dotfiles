-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.check_for_updates_interval_seconds = 604800
config.font_size = 16
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.scrollback_lines = 10000

config.keys = { -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
{
    key = "LeftArrow",
    mods = "OPT",
    action = wezterm.action {
        SendString = "\x1bb"
    }
}, -- Make Option-Right equivalent to Alt-f; forward-word
{
    key = "RightArrow",
    mods = "OPT",
    action = wezterm.action {
        SendString = "\x1bf"
    }
}}

-- and finally, return the configuration to wezterm
return config
