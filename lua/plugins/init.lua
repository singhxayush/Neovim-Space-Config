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


  -- Gen Nvim Integration
{
  "David-Kunz/gen.nvim",
  lazy = false, -- Ensure the plugin loads immediately
  opts = {
    model = "llama3.1", -- Use your installed Llama model
    display_mode = "split",
    show_prompt = true,
    show_model = true,
    no_auto_close = false,
    init = function(options) 
      -- Attempt to start Ollama if it's not running
      pcall(io.popen, "ollama serve > /dev/null 2>&1 &") 
    end,
    command = function(options)
      local body = {
        model = options.model,
        messages = {{role = "user", content = options.prompt}},
        stream = true -- Stream is set to true to handle incremental responses
      }
      -- Encode the JSON body safely for Zsh and curl
      local json_body = vim.fn.json_encode(body)
      -- Escape double quotes and newlines inside the JSON body for Zsh
      local escaped_json_body = json_body:gsub('"', '\\"'):gsub('\n', '\\n')
      local curl_cmd = string.format(
        "curl --silent -X POST http://%s:%s/api/chat -H 'Content-Type: application/json' -d \"%s\"",
        options.host or "localhost",
        options.port or "11434",
        escaped_json_body
      )
      -- Debug print the command
      print(curl_cmd) -- Use this to verify the command
      return curl_cmd
    end,
    debug = true
  },
  config = function(_, opts)
    require("gen").setup(opts)
    
    -- Debug function
    local function debug_print(msg)
      vim.api.nvim_echo({{msg, "WarningMsg"}}, true, {})
    end

    -- Test function
    local function test_gen()
      local prompt = vim.fn.input("Enter your prompt: \n\n") -- Get user input
      debug_print("Testing gen.nvim with Ollama...")
      require("gen").exec("ollama", {
        prompt = prompt, -- Use the captured prompt
        model = "llama3.1",
        override = {
          display_mode = "float",
        },
        callback = function(response)
          debug_print("Received response from Ollama")
          vim.schedule(function()
            print(vim.inspect(response))
          end)
        end,
      })
    end

    -- Keymaps
    vim.keymap.set('v', '<leader>g', ':Gen<CR>')
    vim.keymap.set('n', '<leader>g', function()
      require('gen').select_model()
    end)
    vim.keymap.set('n', '<leader>gt', test_gen, {desc = "Test gen.nvim"})
  end
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


  -- Notification setup
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade_in_slide_out", -- Use slide animation
        timeout = 3000, -- Duration of the notification
        max_width = 80, -- Maximum width of notifications
        max_height = 10, -- Maximum height of notifications
        background_colour = "#000000", -- Background color
        fps = 60, -- Frames per second
        render = "default", -- Render style
        top_down = false, -- Notifications will appear from bottom to top
        minimum_width = 50, -- Set a minimum width for better centering
      })
    end
  },


  -- Auto Save setup
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          message = function() -- message to print on save
            return ("auto saved at " .. vim.fn.strftime("%H:%M:%S"))
          end,
          dim = 0.18, -- dim the color of `message`
          cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
        trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save (see :h events)
        
        condition = function(buf)
          local fn = vim.fn
          local filetype = fn.getbufvar(buf, "&filetype")
          local allowed_filetypes = { 
            "lua", "javascript", "python", "markdown", "c", "cpp", "go", "html", "css", "typescript", "javascriptreact", "typescriptreact"
          } -- specify allowed filetypes here
          
  
          -- Check if the buffer is modifiable and the filetype is in the allowed list
          if
            fn.getbufvar(buf, "&modifiable") == 1 and
            vim.tbl_contains(allowed_filetypes, filetype) then
            return true -- met condition(s), can save
          end
          return false -- can't save
        end,
        
        write_all_buffers = false, -- write all buffers when the current one meets `condition`
        debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
        callbacks = { -- functions to be executed at different intervals
          enabling = nil, -- ran when enabling auto-save
          disabling = nil, -- ran when disabling auto-save
          before_asserting_save = nil, -- ran before checking `condition`
          before_saving = nil, -- ran before doing the actual save
          after_saving = nil -- ran after doing the actual save
        }
      })
    end,
    event = "VeryLazy",
  },


  -- 
  
}
