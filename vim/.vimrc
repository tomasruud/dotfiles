filetype plugin indent on
syntax off

set autoread

set encoding=utf-8

set number
set relativenumber
set ruler

set showmatch

set clipboard+=unnamed
set showmode
set scrolloff=5

set incsearch
set ignorecase
set nohlsearch

set autoindent
set smartindent
set backspace=indent,eol,start

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set path+=** " enable fuzzy like search

let g:netrw_keepdir=0
let g:netrw_fastbrowse=0

let mapleader="\<space>"
nmap <leader>e :Explore<cr>

inoremap jk <esc>`^
