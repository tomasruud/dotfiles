let mapleader="\<space>"

:set number relativenumber

:set clipboard+=unnamed
:set showmode
:set scrolloff=5
:set incsearch
:set ignorecase
:set nohlsearch
:set multiplecursors

:set mouse="a"

:set autoindent
:set smartindent
:set tabstop=4
:set softtabstop=4
:set shiftwidth=4
:set expandtab

:let g:netrw_keepdir=0
:let g:netrw_fastbrowse=0

:nmap <leader>e :Explore<cr>
:nmap <leader>sv :source $MYVIMRC<cr>
:nmap - :m +1<cr>
:nmap _ :m -2<cr>
