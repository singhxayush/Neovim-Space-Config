-- statusbar.lua
local dracula_colors = {
  gray       = '#222a33',
  lightgray  = '#5f6a8e',
  orange     = '#ffb86c',
  purple     = '#83f4fc',
  red        = '#ff6e6e',
  yellow     = '#fffb00',
  green      = '#50fa7b',
  white      = '#f8f8f2',
  black      = '#282a36',
}

local dracula = {
  normal = {
    a = { bg = dracula_colors.purple, fg = dracula_colors.black, gui = 'bold' },
    b = { bg = dracula_colors.lightgray, fg = dracula_colors.white },
    c = { bg = dracula_colors.gray, fg = dracula_colors.white },
  },
  insert = {
    a = { bg = dracula_colors.green, fg = dracula_colors.black, gui = 'bold' },
    b = { bg = dracula_colors.lightgray, fg = dracula_colors.white },
    c = { bg = dracula_colors.gray, fg = dracula_colors.white },
  },
  visual = {
    a = { bg = dracula_colors.yellow, fg = dracula_colors.black, gui = 'bold' },
    b = { bg = dracula_colors.lightgray, fg = dracula_colors.white },
    c = { bg = dracula_colors.gray, fg = dracula_colors.white },
  },
  replace = {
    a = { bg = dracula_colors.red, fg = dracula_colors.black, gui = 'bold' },
    b = { bg = dracula_colors.lightgray, fg = dracula_colors.white },
    c = { bg = dracula_colors.gray, fg = dracula_colors.white },
  },
  command = {
    a = { bg = dracula_colors.orange, fg = dracula_colors.black, gui = 'bold' },
    b = { bg = dracula_colors.lightgray, fg = dracula_colors.white },
    c = { bg = dracula_colors.gray, fg = dracula_colors.white },
  },
  inactive = {
    a = { bg = dracula_colors.gray, fg = dracula_colors.white, gui = 'bold' },
    b = { bg = dracula_colors.lightgray, fg = dracula_colors.white },
    c = { bg = dracula_colors.gray, fg = dracula_colors.white },
  },
}

-- Global variable to track terminal state
_G.is_terminal_open = false

-- Toggle terminal state and color
local function toggle_terminal()
  -- Call your custom terminal toggle function
  require("custom.toggle_terminal").toggle_terminal()

  -- Toggle the terminal state
  _G.is_terminal_open = not _G.is_terminal_open

  -- Redraw the status line to reflect the terminal state
  vim.cmd("redrawstatus")
end


local function has_diagnostics()
  -- Check if there are diagnostics in the current buffer
  local diagnostics = vim.diagnostic.get(0)  -- Get diagnostics for the current buffer (0 means current buffer)
  return #diagnostics > 0
end


-- Define your custom toggle function
_G.toggle_auto_save = function()
  -- Toggle the Auto Save status
  vim.g.isAutoSave = not vim.g.isAutoSave
  auto_save.setup({
      enabled = vim.g.isAutoSave
  })

  -- Get the current time in nanoseconds
  local current_time = vim.loop.hrtime()

  -- Initialize the last notification timestamp and notification ID if not already set
  if not vim.g.last_save_notification_time then
      vim.g.last_save_notification_time = 0
  end

  if not vim.g.last_save_notification_id then
      vim.g.last_save_notification_id = nil
  end

  -- Notify user about the new state
  local status = vim.g.isAutoSave and "enabled" or "disabled"
  local message = string.format("%s", status)
  local level = vim.g.isAutoSave and "info" or "warn"
  local icon = vim.g.isAutoSave and " 󰸞 Auto Save" or "  Auto Save"

  -- If the last notification was sent within 2 seconds, update it instead of creating a new one
  if (current_time - vim.g.last_save_notification_time) <= 2e9 and vim.g.last_save_notification_id then
      vim.notify(message, level, {
          title = "",
          icon = icon,
          timeout = 2000,
          replace = vim.g.last_save_notification_id, -- Update the existing notification
      })
  else
      -- Create a new notification and save its ID
      vim.g.last_save_notification_id = vim.notify(message, level, {
          title = "",
          icon = icon,
          timeout = 2000,
      })
  end

  -- Update the last notification timestamp
  vim.g.last_save_notification_time = current_time

  -- Redraw the status line to reflect the new Auto Save status
  vim.cmd("redrawstatus")
end


return {
  "nvim-lualine/lualine.nvim",
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  event = "VeryLazy",

  config = function()
    require('lualine').setup {
    options = {
      -- theme = 'auto',
      theme = dracula,
      icons_enabled = true,
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ' '},
      always_divide_middle = true,
    },
    sections = {

        ---> LEFT A | B | C
        lualine_a = {
          {
            function()
              return " " -- Terminal icon
            end,
            color = function()
              -- Return different colors based on whether the terminal is open or closed
              if _G.is_terminal_open then
                return { fg = "#83ff75", gui = "bold", bg = "#282a36" } -- Green when open
              else
                return { fg = "#ff8f73", gui = "bold", bg = "#282a36" } -- Red when closed
              end
            end,
            separator = { left = '', right = '' }, -- No separators to reduce extra space
            right_padding = -12, -- No extra padding on the right
    
            -- Implement the on_click functionality for terminal toggle
            on_click = toggle_terminal,
          },
          { 'mode', separator = { left = '', right = '' }, right_padding = 2 }
        },
        lualine_b = { 'filename' ,'branch' },
        lualine_c = {
      {
        function()
          return "Auto Save" -- Fixed text for Auto Save
        end,
        color = { fg = "#E4E4E4", gui = "bold" }, -- Gray and bold color for "Auto Save"
        separator = { left = '', right = '' }, -- No extra space on the right
        right_padding = 0, -- No extra padding on the right
      },
      {
        function()
          -- Return the status part to apply different colors
          if vim.g.isAutoSave == nil then
            return "N/A"
          elseif vim.g.isAutoSave then
            return "." -- Icon for ON
          else
            return "." -- Icon for OFF
          end
        end,
        color = function()
          if vim.g.isAutoSave == nil then
            return { fg = "#ffafaf" } -- Light color for N/A
          elseif vim.g.isAutoSave then
            return { fg = "#83ff75" } -- Green color for ON
          else
            return { fg = "#ff8f73" } -- Red color for OFF
          end
        end,
        separator = { left = '', right = '' }, -- No separators to reduce extra space
        right_padding = -12, -- No extra padding on the right

        -- Implement the on_click functionality
        on_click = function()
          -- Call your custom notification update function
          _G.toggle_auto_save()
        end,
      },
    },

        ---> RIGHT X | Y | Z
        lualine_x = {
          'encoding',
          'fileformat',
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            sections = { 'error', 'warn', 'info', 'hint' },
            symbols = { error = '  ', warn = '  ', info = '  ', hint = '  ' },
            colored = true,           -- Displays diagnostics with color based on severity
            update_in_insert = true, -- Update diagnostics in insert mode
            always_visible = false,  -- Show diagnostics only when there are diagnostics
            cond = has_diagnostics,   -- Show diagnostics only if the function returns true
            separator = { right = '', left = '' },
          },
        },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '', left = '' }, left_padding = 2 },
        },
    },

    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
    },

    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  }
  end,
}
