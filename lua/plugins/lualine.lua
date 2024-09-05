local dracula_colors = {
  gray       = '#44475a',
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

  
return {
  "nvim-lualine/lualine.nvim",
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  event = "VeryLazy",
  config = function()
    require('lualine').setup {
    options = {
        theme = dracula,
        component_separators = '',
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { { 'mode', separator = { left = ' ' }, right_padding = 2 } },
        lualine_b = { 'filename', 'branch' },
        lualine_c = {''},

        lualine_x = {
          'encoding',
          'fileformat',
          {
            'diagnostics',
            sources = {'nvim_lsp'},
            sections = { 'error', 'warn', 'info', 'hint' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            colored = true,           -- Displays diagnostics with color based on severity
            update_in_insert = false, -- Update diagnostics in insert mode
            always_visible = true,    -- Show diagnostics even if there are none
          }
        },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
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
