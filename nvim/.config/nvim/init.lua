---@diagnostic disable:undefined-global

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.showmode = true
vim.opt.scrolloff = 5

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = "indent,eol,start"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>f", "<cmd>Telescope find_files hidden=true no_ignore=false<cr>", desc = "Open file finder" },
      },
  },
})
