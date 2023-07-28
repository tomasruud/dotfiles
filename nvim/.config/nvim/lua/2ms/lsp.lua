local lspconfig = require("lspconfig")

-- lua
lspconfig.lua_ls.setup({})

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

