vim.keymap.set('n', '<Leader>o', function()
    vim.lsp.buf.code_action({
        context = {
            only = {
                'source.organizeImports',
            },
        },
        apply = true,
    })
end)

