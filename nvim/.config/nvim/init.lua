-- shared config
vim.cmd("source $HOME/.vimrc")

-- general
vim.opt.clipboard = 'unnamedplus'


-- local plugins
require("statusline")

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

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
