return {


  -- Auto Tags for HTML
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require('nvim-ts-autotag').setup({
        -- Global settings
        enable = true, -- Enable autotag globally
        filetypes = {
          "html", "javascript", "javascriptreact", "typescriptreact", "vue", "xml", "php", "markdown", "typescript", "go"
        },
        -- Options
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        },
        -- Per filetype override (if needed)
        per_filetype = {
          html = {
            enable_close = true,
            enable_rename = true
          },
          javascriptreact = {
            enable_close = true,
            enable_rename = true
          },
          typescriptreact = {
            enable_close = true,
            enable_rename = true
          }
        }
      })
    end,
  },  


  -- File Tree
  {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons", -- Optional, for file icons
    config = function()
      require("nvim-tree").setup({
        view = {
          adaptive_size = true,  -- Automatically adjusts the width based on the longest file name
        },
        git = {
          enable = true,
        },
      })
    end,
  },


  -- References
  -- LSP: https://github.com/neovim/nvim-lspconfig
  -- Formatters: https://github.com/stevearc/conform.nvim
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Existing tools
        "css-lsp",
        "html-lsp",
        "lua-language-server",
        "stylua",
  
        -- Go tools
        "gopls",           -- Go language server
        "golangci-lint",   -- Go linter
        "gofumpt",         -- Go formatters
        "golines",
        "goimports",
        "delve",           -- Go debugger
  
        -- JavaScript/TypeScript tools
        "typescript-language-server", -- JS/TS language server
        "eslint-lsp",                 -- JavaScript linter
        "prettierd",                  -- JavaScript formatter
        "js-debug-adapter",           -- JavaScript debugger

        -- C/C++
        "cpplint",
        -- "clangd",           -- C/C++ LSP
        -- "clang-format",     -- C/C++ formatter

        -- Python
        "pyright",  -- Python LSP
        "isort",    -- Python formatters
        "black",
      },
    },
  },



  {
    "rainbowhxch/beacon.nvim",
    event = "VeryLazy",
  },


  -- Format on Save
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },


  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
	  opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "json",
        "go", "gomod", "gosum",
        "javascript", "typescript",
        "cpp", "c", "python",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },


  -- Noice integration
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false, -- Disable signature help in noice.nvim to avoid conflict
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      views = {
        cmdline_popup = {
          position = {
            row = "50%",  -- Center vertically
            col = "50%",  -- Center horizontally
          },
          size = {
            width = 60,   -- Adjust width as needed
            height = "auto",  -- Auto height based on content
          },
          border = {
            style = "rounded",  -- Optional: add a rounded border
          },
          -- Add a background behind the command line popup
          win_options = {
            winblend = 0,  -- Make background fully opaque
            winhighlight = "Normal:Normal",  -- Adjust highlight if necessary
          },
        },
        popupmenu = {
          relative = "editor", -- Position relative to the editor window
          position = {
            row = "52%",  -- Slightly below the cmdline_popup
            col = "50%",  -- Center horizontally
          },
          size = {
            width = 60,   -- Match the cmdline_popup width
            height = 10,  -- Set height for the popup menu
          },
          border = {
            style = "rounded",  -- Optional rounded border
          },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },



  -- {
  --   "yamatsum/nvim-cursorline",
  --   config = function()
  --     require('nvim-cursorline').setup {
  --       cursorline = {
  --         enable = true,
  --         timeout = 1000,
  --         number = false,
  --       },
  --       cursorword = {
  --         enable = true,
  --         min_length = 3,
  --         hl = { underline = true },
  --       }
  --     }
  --   end,
  -- }
}
