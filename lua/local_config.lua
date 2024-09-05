-- ~/.config/nvim/lua/local_config.lua

local toggle_terminal = require('custom.toggle_terminal')

-- Key mappings for toggling terminal
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua require("custom.toggle_terminal").toggle_terminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<leader>tt', '<C-\\><C-n>:lua require("custom.toggle_terminal").toggle_terminal()<CR>', { noremap = true, silent = true })
