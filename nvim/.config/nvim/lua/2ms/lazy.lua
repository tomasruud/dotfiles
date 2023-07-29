local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "owickstrom/vim-colors-paramount",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme paramount]])
        end,
    },

    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        commit = "7d15094",
        config = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.opt.background = "dark"
            end,
            set_light_mode = function()
                vim.opt.background = "light"
            end,
        },
        init = function()
            require("auto-dark-mode").init()
        end,
    },

    {
        "neovim/nvim-lspconfig",
        version = "^0.1.6",
        servers = {
            lua_ls = {},

            gopls = {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                    },
                },
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        version = "^0.6.0"
    },

    {
        "folke/neodev.nvim",
        version = "^2.5.2",
    },

    {
        "nvim-telescope/telescope.nvim",
        version = "^0.1.2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
})

