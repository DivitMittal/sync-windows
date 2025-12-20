return function(wezterm, config)
  config.term = "xterm-256color"
  config.enable_kitty_graphics = true
  config.default_prog = { "pwsh.exe", '-NoLogo'}

  -- font
  config.font = wezterm.font "Cascadia Code"
  config.font_size = 12
  config.adjust_window_size_when_changing_font_size = false
  config.custom_block_glyphs = false
  config.harfbuzz_features = {
    "calt=1",
    "clig=1",
    "liga=1",
  }

  -- appearance
  config.window_close_confirmation = "NeverPrompt"
  config.colors = {
    foreground = "silver",
    background = "black",
    --cursor
    cursor_bg = "red",
    cursor_fg = "silver",
    cursor_border = "silver",
  }
  config.default_cursor_style = "SteadyBar"
  config.initial_cols = 80
  config.initial_rows = 20
  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
  config.window_background_opacity = 0.90
  config.window_decorations = "RESIZE"
  config.enable_scroll_bar = false

  -- hyperlink
  config.hyperlink_rules = {
    {
      regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
      format = "$0",
    },
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = "mailto:$0",
    },
    {
      regex = [[\bfile://\S*\b]],
      format = "$0",
    },
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = "$0",
    },
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = "https://www.github.com/$1/$3",
    },
  }
end
