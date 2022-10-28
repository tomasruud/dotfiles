```shell
echo ".dotfiles" >> $HOME/.gitignore
git clone --bare git@github.com:tomasruud/dot.git $HOME/.dotfiles

alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

mkdir -p $HOME/.dotfiles-backup && \
dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} $HOME/.dotfiles-backup/{}

dot checkout

touch $HOME/.config/git/config

dot config --local status.showUntrackedFiles no

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install go java php neovim node ripgrep fd 
brew install --cask gnucash warp tidal jetbrains-toolbox firefox microsoft-teams slack insomnia docker monitorcontrol visual-studio-code
