local lspconfig = require('lspconfig')

-- lua
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})

-- typescript
lspconfig.tsserver.setup({})

-- go
lspconfig.gopls.setup({
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
        },
    },
})


