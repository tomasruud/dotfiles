let mapleader = "\<Space>"

set number

set showmode
set scrolloff=5
set incsearch
set ignorecase

if has('ide')
    " IdeaVim options
    set iderefactormode=keep
    set clipboard=unnamedplus,unnamed,idea

    set ideajoin
    set NERDTree

    map <leader>e <Action>(ActivateProjectToolWindow)
    map <leader>r <Action>(RecentFiles)
    map <leader>b <Action>(GotoDeclaration)
    map <leader>i <Action>(GotoImplementation)

elseif has('nvim')
    " NeoVim options

else
    " Vim options

endif
