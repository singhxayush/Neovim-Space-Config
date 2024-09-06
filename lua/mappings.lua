require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map('n', '<leader>fk', '<cmd>Telescope keymaps<CR>', { desc = "Show Telescope keymaps" })
map('n', '<leader>qq', '<cmd>qall<CR>', {desc = "Quit all"})



vim.api.nvim_set_keymap("n", "<leader>mm", ":ASToggle<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<C-\\>', '<C-w>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-\\>', '<C-w>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-;>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-;>', '<C-w>w', { noremap = true, silent = true })


-- In your key mappings configuration file
-- vim.api.nvim_set_keymap('n', '<Space>mm', ":lua require('auto-save').toggle()<CR>:lua require('lualine').refresh()<CR>", { noremap = true, silent = true })


-- Key mappings for toggling terminal
local toggle_terminal = require('custom.toggle_terminal')
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua require("custom.toggle_terminal").toggle_terminal()<CR>', { desc = "Toggle Terminal", noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<leader>tt', '<C-\\><C-n>:lua require("custom.toggle_terminal").toggle_terminal()<CR>', { desc = "Toggle Terminal", noremap = true, silent = true })