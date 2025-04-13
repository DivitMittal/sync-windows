require "nvchad.options"

-- ────────────────❰ Settings ❱─────────────── --
local set = vim.opt -- global options(with lua syntax)

-- Enable GUI colors for the terminal to get truecolor
set.termguicolors = true

-- show whitespace
set.list = true
set.listchars = {
  nbsp = "␣",
  extends = "»",
  precedes = "«",
  tab = "|-",
  trail = "•",
  space = "·",
  eol = "ꜜ",
}

set.fillchars = {
  diff = "∙",
  eob = " ", -- NOBREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
  fold = "·",
  vert = " ", -- remove ugly vertical lines on window division
}

-- patterns to ignore during file-navigation
set.wildignore:append {
  "*.o",
  "*.rej",
  "*.so",
}

set.wrap = true -- automatically wrap on load
set.breakindent = true -- automatically break lines on load with respect to indent
--set.cursorcolumn   = true                              -- highlight current column
--set.cursorline     = true                              -- highlight current line
set.number = true -- show line numbers
set.relativenumber = true -- show relative line number
set.mouse = "a" -- turn on mouse interaction
set.laststatus = 2 -- always show status line
--set.scrolloff     = 1                                  -- when scrolling, keep cursor 1 lines away from screen border
--set.sidescrolloff = 2                                  -- keep 30 columns visible left and right of the cursor at all times
set.backspace = "indent,start,eol" -- make backspace behave like normal again
set.lazyredraw = true -- faster scrolling
set.updatetime = 1000 -- CursorHold interval
set.completeopt = "menuone,noselect,noinsert" -- completion options
set.inccommand = "split" -- live preview of :s results

set.clipboard = set.clipboard + "unnamedplus" -- copy & paste
set.showmatch = true -- show the matching part of the pair for [] {} and ()

set.incsearch = true -- incremental search
set.hlsearch = true -- highlighted search results
set.ignorecase = true -- ignore case sensetive while searching
set.smartcase = true -- ignore case off when an uppercase character in query

set.expandtab = true -- expand tabs into spaces
-- plugin guess-indent sets the following dynamically & editorconfig sets the defaults
--set.tabstop         = 2                                -- actual spaces which are considered a tab
--set.smarttab        = true                             -- <tab>/<BS> indent/dedent in leading whitespace
--set.softtabstop     = 2                                -- how many spaces are inserted and delted when pressing tab and bs respectively
--set.shiftwidth      = 2                                -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
set.shiftround = true -- round shiftwidth to the nearest multiple of shiftwidth

set.smartindent = true -- indent the current line according to the previous line
set.autoindent = true -- maintain indent of current line

set.shell = "fish" -- shell to use for `!`, `:!`, `system()` etc.

set.splitbelow = true -- open horizontal splits below current window
set.splitright = true -- open vertical splits to the right of the current window
