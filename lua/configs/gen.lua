-- local opts = {
--     model = "llama3.1",
-- }

-- require("gen").setup(opts)


local gen = require("gen")

gen.setup({
    model = "ollama/llama3.1", -- Specifying Ollama provider and model
    display_mode = "float",
})

-- Optional: Add a custom command to change the model
vim.api.nvim_create_user_command("GenChangeModel", function(opts)
    gen.opts.model = "ollama/" .. opts.args
end, { nargs = 1 })

-- Define some prompts
gen.prompts['fix_bugs'] = {
    prompt = "Fix bugs in the following code:\n```$filetype\n$text\n```",
    replace = true
}

gen.prompts['explain_code'] = {
    prompt = "Explain the following code:\n```$filetype\n$text\n```",
}

-- Keymaps
vim.keymap.set('v', '<leader>gc', ':Gen<CR>')
vim.keymap.set('n', '<leader>gf', ':Gen fix_bugs<CR>')
vim.keymap.set('n', '<leader>ge', ':Gen explain_code<CR>')
