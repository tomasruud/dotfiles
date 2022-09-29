# Install
```shell
# add gitignore thing
echo ".dotfiles" >> $HOME/.gitignore

# clone the repo
git clone --bare git@github.com:tomasruud/dot.git $HOME/.dotfiles

# checkout code and try to move conflicting files automatically
mkdir -p $HOME/.dotfiles-backup && \
dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} $HOME/.dotfiles-backup/{}

# do the checkout again if it failed previously
dot checkout

# create separate git config
touch $HOME/.config/git/config

# make sure to configure dotfiles repo to not show untracked files
dot config --local status.showUntrackedFiles no

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install go java php neovim node ripgrep fd visual-studio-code
brew install --cask gnucash warp tidal jetbrains-toolbox firefox microsoft-teams slack insomnia docker
```