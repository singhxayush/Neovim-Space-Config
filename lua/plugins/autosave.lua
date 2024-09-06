-- Auto Save setup
return {
    "Pocco81/auto-save.nvim",
    config = function()
        local auto_save = require("auto-save")
        local notify = require("notify")

        -- Initialize global variable to track auto-save status
        vim.g.isAutoSave = true
        vim.g.last_save_notification = 0


        -- Variable to store the last notification message
        _G.auto_save_status_message = ""

        -- Function to toggle auto-save
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
        


        -- Set up auto-save
        auto_save.setup({
            enabled = vim.g.isAutoSave,
            execution_message = {
            message = function()
                -- Custom notification on save
                local current_time = os.time()
                local status = "Saved at " .. vim.fn.strftime("%H:%M:%S")
                local message = string.format("%s", status)
                local level = "info"

                -- Only notify if it's a fresh notification
                if not vim.g.last_save_notification or (current_time - vim.g.last_save_notification > 2) then
                vim.notify(message, level, {
                    title = "",
                    icon = "   Autosave",
                    timeout = 2000
                })
                -- Update the last notification timestamp
                vim.g.last_save_notification = current_time
                end
                return ""
            end,
            dim = 0.18,
            cleaning_interval = 1250,
            },
            trigger_events = {"InsertLeave", "TextChanged"},
            condition = function(buf)
            if not vim.g.isAutoSave then
                return false
            end
            local fn = vim.fn
            local filetype = fn.getbufvar(buf, "&filetype")
            local allowed_filetypes = {
                "lua", "javascript", "python", "markdown", "c", "cpp", "go", "html", "css", "typescript", "javascriptreact", "typescriptreact"
            }
            return fn.getbufvar(buf, "&modifiable") == 1 and vim.tbl_contains(allowed_filetypes, filetype)
            end,
            write_all_buffers = false,
            debounce_delay = 135,
        })

      -- Set up the keybinding
      vim.api.nvim_set_keymap('n', '<space>mm', ':lua toggle_auto_save()<CR>', {desc = "Toggle Auto Save", noremap = true, silent = true })
    end,
    event = "VeryLazy",
}







--   -- Auto Save setup
-- return {
--     "Pocco81/auto-save.nvim",
--     config = function()
--       require("auto-save").setup({
--         enabled = true,
--         execution_message = {
--           message = function() -- message to print on save
--             return ("auto saved at " .. vim.fn.strftime("%H:%M:%S"))
--           end,
--           dim = 0.18, -- dim the color of `message`
--           cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
--         },
--         trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save (see :h events)
        
--         condition = function(buf)
--           local fn = vim.fn
--           local filetype = fn.getbufvar(buf, "&filetype")
--           local allowed_filetypes = { 
--             "lua", "javascript", "python", "markdown", "c", "cpp", "go", "html", "css", "typescript", "javascriptreact", "typescriptreact"
--           } -- specify allowed filetypes here
          
  
--           -- Check if the buffer is modifiable and the filetype is in the allowed list
--           if
--             fn.getbufvar(buf, "&modifiable") == 1 and
--             vim.tbl_contains(allowed_filetypes, filetype) then
--             return true -- met condition(s), can save
--           end
--           return false -- can't save
--         end,
        
--         write_all_buffers = false, -- write all buffers when the current one meets `condition`
--         debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
--         callbacks = { -- functions to be executed at different intervals
--           enabling = nil, -- ran when enabling auto-save
--           disabling = nil, -- ran when disabling auto-save
--           before_asserting_save = nil, -- ran before checking `condition`
--           before_saving = nil, -- ran before doing the actual save
--           after_saving = nil -- ran after doing the actual save
--         }
--       })
--     end,
--     event = "VeryLazy",
-- }
