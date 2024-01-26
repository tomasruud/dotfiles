# dotfiles

## Setting up

1. Install Homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" `
1. Add Homebrew binaries to path `export PATH="PATH:/opt/homebrew/bin"`
1. Clone the repo `git clone --recurse-submodules https://github.com/tomasruud/dotfiles.git $HOME/dotfiles`
1. Setup Homebrew bundle using `$HOME/dotfiles/brew/setup`
1. Install the dotfiles using `$HOME/dotfiles/dot/sync`


## Installing zsh plugins
Use `git submodule add -f <repo-url> ./zsh/.config/zsh/plugins/<plugin-name>` to install.

