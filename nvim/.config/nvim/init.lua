vim.cmd("source $HOME/.vimrc")

vim.opt.clipboard = 'unnamedplus'


lspconfig = require'lspconfig'
util = require'lspconfig/util'

lspconfig.tsserver.setup{}

lspconfig.gopls.setup{
    settings = {
        gopls = {
            analyses = {unusedparams = true},
        },
    },
}

vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.lsp.buf.format()
    end,
})

vim.api.nvim_create_autocmd({'BufWritePre', 'InsertLeave'}, {
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.code_action({context = {only = {'source.organizeImports'}}, apply = true})
    end,
})
