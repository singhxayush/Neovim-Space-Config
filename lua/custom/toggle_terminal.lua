-- ~/.config/nvim/lua/custom/toggle_terminal.lua

local M = {}

-- Store the terminal buffer/window ID, last active window ID, and line number settings
local terminal_bufnr = nil
local terminal_winid = nil
local last_winid = nil
local last_win_number = nil
local last_win_relativenumber = nil

function M.toggle_terminal()
    -- If terminal is open, close it
    if terminal_winid and vim.api.nvim_win_is_valid(terminal_winid) then
        vim.api.nvim_win_hide(terminal_winid)
        terminal_winid = nil

        -- Restore focus to the last active window
        if last_winid and vim.api.nvim_win_is_valid(last_winid) then
            vim.api.nvim_set_current_win(last_winid)
            
            -- Restore line number settings based on the last active window
            if last_win_number ~= nil then
                vim.wo.number = last_win_number
                vim.wo.relativenumber = last_win_relativenumber
            end
        end
    else
        -- Store the last active window ID and line number settings before opening the terminal
        last_winid = vim.api.nvim_get_current_win()
        last_win_number = vim.wo.number
        last_win_relativenumber = vim.wo.relativenumber

        -- Open the terminal if it's not open
        if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
            -- Open the terminal buffer in a new split
            vim.cmd('botright split')
            vim.api.nvim_set_current_buf(terminal_bufnr)
            terminal_winid = vim.api.nvim_get_current_win()
        else
            -- If no terminal buffer exists, create a new one
            vim.cmd('botright split | terminal')
            terminal_bufnr = vim.api.nvim_get_current_buf()
            terminal_winid = vim.api.nvim_get_current_win()

            -- Set up an autocommand to handle terminal buffer deletion
            vim.api.nvim_create_autocmd("BufDelete", {
                buffer = terminal_bufnr,
                callback = function()
                    terminal_bufnr = nil
                    terminal_winid = nil
                    -- Restore focus to the last active window
                    if last_winid and vim.api.nvim_win_is_valid(last_winid) then
                        vim.api.nvim_set_current_win(last_winid)
                        
                        -- Restore line number settings based on the last active window
                        if last_win_number ~= nil then
                            vim.wo.number = last_win_number
                            vim.wo.relativenumber = last_win_relativenumber
                        end
                    end
                end
            })
        end

        -- Automatically enter terminal mode
        vim.cmd('startinsert')

        -- Hide line numbers for the terminal window
        vim.wo.number = false
        vim.wo.relativenumber = false
    end
end

return M
