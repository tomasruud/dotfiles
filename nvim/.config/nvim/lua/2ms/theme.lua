vim.cmd("colorscheme paramount")

local auto_dark_mode = require("auto-dark-mode")

auto_dark_mode.setup({
    set_dark_mode = function()
        vim.opt.background = "dark"
    end,
    set_light_mode = function()
        vim.opt.background = "light"
    end,
})

auto_dark_mode.init()

