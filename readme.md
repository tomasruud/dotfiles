```shell
echo ".dotfiles" >> $HOME/.gitignore
git clone --bare git@github.com:tomasruud/dot.git $HOME/.dotfiles

alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no

touch $HOME/.config/git/config

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install go java php neovim node ripgrep fd visual-studio-code
brew install --cask gnucash warp tidal jetbrains-toolbox firefox microsoft-teams slack insomnia docker
```