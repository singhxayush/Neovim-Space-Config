require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map('n', '<leader>fk', '<cmd>Telescope keymaps<CR>', { desc = "Show Telescope keymaps" })
map('n', '<leader>qq', '<cmd>qall<CR>', {desc = "Quit all"})
map('n', '<leader>mm', '<cmd>ASToggle', {desc = "Toggle auto save"})
-- map('n', '<C-/>', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { desc = "Comment current line" })



vim.api.nvim_set_keymap("n", "<leader>mm", ":ASToggle<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<C-\\>', '<C-w>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-\\>', '<C-w>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-;>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-;>', '<C-w>w', { noremap = true, silent = true })