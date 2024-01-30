# dotfiles

```shell
# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# add Homebrew binaries to path
export PATH="PATH:/opt/homebrew/bin"

# clone the repo 
git clone --recurse-submodules https://github.com/tomasruud/dotfiles.git $HOME/dotfiles

# install Homebrew packages
$HOME/dotfiles/brew/setup

# sync dotfiles
$HOME/dotfiles/dot/sync

# install LSPs
$HOME/dotfiles/helix/setup-lsps

# install binaries
$HOME/dotfiles/bin/install
```

## Installing zsh plugins
Use `git submodule add -f <repo-url> ./zsh/.config/zsh/plugins/<plugin-name>` to install.

