local wezterm = require "wezterm"
local config = wezterm.config_builder()

require "options"(wezterm, config)
require "binds"(wezterm, config)
require "smartSplits"(wezterm, config)
require "tabline"(wezterm, config)

return config
