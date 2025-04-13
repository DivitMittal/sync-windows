local isVSCode = vim.g.vscode -- set by vscode neovim extension

return {
  -- ----------------------------------------------------------- --
  --                   Default Plugins
  -- ----------------------------------------------------------- --
  {
    "NvChad/NvChad",
    enabled = true,
    cond = not isVSCode,
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  -- ----------------------------------------------------------- --
  --                   Overrides
  -- ----------------------------------------------------------- --
  -- file explorer/navigation
  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    cond = not isVSCode,
    opts = {
      git = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    enabled = true,
    cond = not isVSCode,
    cmd = { "ConformInfo" },
    opts = function(_, _)
      return require "configs.conform_opts"
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        mode = { "n", "v" },
        "<leader>fm",
        function()
          require("conform").format { async = true }
        end,
        desc = "Format buffer",
      },
    },
  },

  -- configure the neovim native LSP client
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    cond = not isVSCode,
    config = function()
      require "configs.lsp_config"
    end,
  },

  -- treesitter syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    cond = not isVSCode,
    opts = require "configs.treesitter_opts",
    config = function(_, opts)
      require("nvim-treesitter.install").compilers = { "clang" }
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- {
  --   -- LSPs, DAPs, Linters & Formatters Packages Management
  --   "williamboman/mason.nvim",
  --   enabled = false,
  --   cond = not isVSCode,
  --   -- automatic setup of lspconfig for Mason installed LSPs
  --   dependencies = {
  --     "williamboman/mason-lspconfig.nvim",
  --     enabled = false,
  --     cond = not isVSCode,
  --     config = function()
  --       require("mason-lspconfig").setup()
  --       require("mason-lspconfig").setup_handlers({
  --         function(server_name)
  --           require("lspconfig")[server_name].setup({})
  --         end,
  --       })
  --     end,
  --   },
  -- },

  -- ----------------------------------------------------------- --
  --                   Custom Plugins
  -- ----------------------------------------------------------- --
  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example

  -- Automatically set indentation/tabstop space size of the current buffer
  {
    "nmac427/guess-indent.nvim",
    enabled = true,
    cond = not isVSCode,
    event = "InsertEnter",
    opts = {
      auto_cmd = true,
      override_editorconfig = false, -- Set to true to override settings set by .editorconfig

      filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
        "tutor",
      },
      "netrw",
      buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
      on_tab_options = { -- A table of vim options when tabs are detected
        ["expandtab"] = false,
      },
      on_space_options = { -- A table of vim options when spaces are detected
        ["expandtab"] = true,
        ["tabstop"] = "detected", -- If the option value is 'detected', The value is set to the automatically detected indent size.
        ["softtabstop"] = "detected",
        ["shiftwidth"] = "detected",
      },
    },
  },

  -- Collection of nvim plugins
  {
    "echasnovski/mini.nvim",
    enabled = true,
    event = "BufEnter",
    config = function()
      -- require('mini.jump2d').setup({ labels = 'oienarstwqyxcpl' }) -- EasyMotion/Hop like plugin ( using flash.nvim instead )
      require("mini.align").setup {} -- vim-easy-align like plugin
      require("mini.surround").setup {} -- vim-surround lke plugin

      -- vim-move like plugin
      require("mini.move").setup {
        mappings = {
          -- Move visual selection in Visual mode.
          left = "<S-Left>",
          right = "<S-Right>",
          down = "<S-Down>",
          up = "<S-Up>",
          -- Move current line in Normal mode
          line_left = "<S-Left>",
          line_right = "<S-Right>",
          line_down = "<S-Down>",
          line_up = "<S-Up>",
        },
        options = { reindent_linewise = true },
      }
    end,
  },

  -- vim-vinegar like plugin for filesystem manipulation
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    cond = not isVSCode,
    event = "VeryLazy",
    cmd = "Oil",
    opts = {},
    keys = {
      { mode = { "n" }, "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
  },

  -- vim-seek/vim-sneak/lightspeed.nvim/mini-jump.nvim/leap.nvim like plugin for multi-charater searching & jumping
  {
    "folke/flash.nvim",
    enabled = true,
    cond = not isVSCode,
    event = "VeryLazy",
    opts = {
      labels = "tsraneiofuplwykdq",
      highlight = { backdrop = false },
      modes = {
        char = {
          enabled = true,
          highlight = { backdrop = false },
        },
        search = { enabled = false },
      },
    },
    keys = {
      {
        mode = { "n", "x", "o" },
        "<cr>",
        function()
          require("flash").jump()
        end,
        desc = "flash",
      },
      {
        mode = { "n", "x", "o" },
        "s",
        function()
          require("flash").treesitter()
        end,
        desc = "flash  treesitter",
      },
      -- { mode = { "o", "x" }, "r"   , function() require("flash").treesitter_search() end, desc = "treesitter search" },
      -- { mode = { "c" }, "<c-s>", function() require("flash").toggle() end, desc = "toggle flash search" },
      -- { mode = "o"    , "r"    , function() require("flash").remote() end, desc = "Remote Flash" },
    },
  },

  -- diagnostics
  {
    "folke/trouble.nvim",
    enabled = true,
    cond = not isVSCode,
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- manoeuvre around splits b/w multiplexers & nvim-splits
  {
    "mrjones2014/smart-splits.nvim",
    enabled = true,
    cond = not isVSCode,
    event = "BufEnter",
    opts = {},
    keys = {
      {
        mode = { "n" },
        "<C-Left>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "move   cursor left  across splits",
      },
      {
        mode = { "n" },
        "<C-Right>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "move   cursor right across splits",
      },
      {
        mode = { "n" },
        "<C-Down>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "move   cursor down  across splits",
      },
      {
        mode = { "n" },
        "<C-Up>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "move   cursor up    across splits",
      },
      {
        mode = { "n" },
        "<A-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "resize pane   up    across splits",
      },
      {
        mode = { "n" },
        "<A-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "resize pane   down  across splits",
      },
      {
        mode = { "n" },
        "<A-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "resize pane   right across splits",
      },
      {
        mode = { "n" },
        "<A-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "resize pane   left  across splits",
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cond = not isVSCode,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 100,
        keymap = {
          accept = "<M-a>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-n>",
          prev = "<M-p>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        layout = {
          position = "top",
          ratio = 0.4,
        },
        keymap = {
          jump_prev = "<M-p>",
          jump_next = "<M-n>",
          accept = "<CR>",
          refresh = "gr",
        },
      },
    },
    keys = {
      {
        mode = { "n", "v" },
        "<leader>cp",
        function()
          require("copilot.panel").toggle()
        end,
        desc = "toggle copilot panel",
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    cond = not isVSCode,
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    event = "VeryLazy",
    opts = {},
  },

  -- ----------------------------------------------------------- --
  --                Custom Disabled Plugins
  -- ----------------------------------------------------------- --
  -- multicursors.nvim & hydra.nvim(custom keybinding creation)
  -- {
  --   "smoka7/multicursors.nvim",
  --   dependencies = { "smoka7/hydra.nvim" },
  --   enabled = false,
  --   cond = not isVSCode,
  --   event = "VeryLazy",
  --   opts = {},
  --   cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  --   keys = {
  --     { mode = { "v", "n" }, "<leader>mc", "<cmd>MCstart<cr>", desc = "selected word under the cursor and listen for actions", },
  --   },
  -- },

  -- Linting
  -- {
  --   "mfussenegger/nvim-lint",
  --   enabled = false,
  --   cond = not isVSCode,
  --   event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  --   opts = function(_, conf) return require("configs.lint_opts") end,
  --   config = function(_, opts)
  --     local lint = require('lint')
  --     lint.linters_by_ft = opts
  --     vim.api.nvim_create_autocmd({"BufWritePost", "BufReadPost", "InsertLeave"}, {
  --       group = vim.api.nvim_create_augroup("lint", { clear = true }),
  --       pattern = "*",
  --       callback = function() lint.try_lint() end,
  --     })
  --   end,
  -- },
}
