-- Notification setup
return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    -- Set up custom highlights
    vim.cmd([[
      highlight NotifyERRORBorder guifg=#8A1F1F
      highlight NotifyWARNBorder guifg=#79491D
      highlight NotifyINFOBorder guifg=#4F6752
      highlight NotifyDEBUGBorder guifg=#8B8B8B
      highlight NotifyTRACEBorder guifg=#4F3552
      highlight NotifyERRORIcon guifg=#F70067
      highlight NotifyWARNIcon guifg=#F79000
      highlight NotifyINFOIcon guifg=#A9FF68
      highlight NotifyDEBUGIcon guifg=#8B8B8B
      highlight NotifyTRACEIcon guifg=#D484FF
      highlight NotifyERRORTitle  guifg=#F70067
      highlight NotifyWARNTitle guifg=#F79000
      highlight NotifyINFOTitle guifg=#A9FF68
      highlight NotifyDEBUGTitle  guifg=#8B8B8B
      highlight NotifyTRACETitle  guifg=#D484FF
      highlight link NotifyERRORBody Normal
      highlight link NotifyWARNBody Normal
      highlight link NotifyINFOBody Normal
      highlight link NotifyDEBUGBody Normal
      highlight link NotifyTRACEBody Normal
    ]])

    notify.setup({
      stages = "fade",
      timeout = 3000, -- Duration of the notification
      -- min_width = 20,
      -- max_width = 40, -- Maximum width of notifications
      -- min_height = 10, -- Maximum height of notifications
      -- max_height = 20, -- Maximum height of notifications
      -- background_colour = "#000000", -- Background color
      fps = 60, -- Frames per second
      render = "compact", -- default, minimal, simple, compact, wrapped-compact
      top_down = true, -- Notifications will appear from bottom to top
      minimum_width = 50, -- Set a minimum width for better centering
    })
    
    -- Set notify as the default notification handler
    vim.notify = notify
  end
}


-- -- Notification setup
-- return {
--     "rcarriga/nvim-notify",
--     config = function()
--       local notify = require("notify")
--       notify.setup({
--         stages = "fade",
--         timeout = 3000, -- Duration of the notification
--         max_width = 80, -- Maximum width of notifications
--         max_height = 20, -- Maximum height of notifications
--         background_colour = "#000000", -- Background color
--         fps = 60, -- Frames per second
--         render = "default", -- Render style
--         top_down = true, -- Notifications will appear from bottom to top
--         minimum_width = 50, -- Set a minimum width for better centering
--       })
      
--       -- Set notify as the default notification handler
--       vim.notify = notify
--     end
--   }