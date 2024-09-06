

-- Gen Nvim Integration
return {
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
}