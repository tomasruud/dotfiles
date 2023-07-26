-- shared config
vim.cmd("source $HOME/.vimrc")

-- general
vim.opt.clipboard = 'unnamedplus'

-- lsp
local lspconfig = require 'lspconfig'

-- lsp/lua
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
}

-- lsp/typescript
lspconfig.tsserver.setup {}

-- lsp/go
lspconfig.gopls.setup {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
        },
    },
}

-- keymaps
vim.keymap.set('n', '<Leader>/', ':noh<cr>')
vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format)
