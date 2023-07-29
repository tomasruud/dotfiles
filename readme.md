# dotfiles

## Setting up

1. Restore secrets backup.
1. Install xcode command line tools. Homebrew might try to install this for you.
1. Install Homebrew
1. Install GNU Stow
1. Clone the repo `git clone --recurse-submodules git@github.com:tomasruud/dotfiles.git $HOME/dotfiles`
1. Install the dotfiles using `./dot install`
1. Setup Homebrew bundle using `./dot brew:setup`

## Installing zsh plugins
Use `git submodule add -f <repo-url> ./zsh/.config/zsh/plugins/<plugin-name>` to install.

