vim.cmd("source $HOME/.vimrc")

vim.opt.clipboard = 'unnamedplus'

require'lspconfig'.tsserver.setup {}
