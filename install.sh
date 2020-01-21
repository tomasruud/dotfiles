#!/bin/bash
# most of these steps are from the guide at 
# https://www.atlassian.com/git/tutorials/dotfiles

# make sure git with ssh is set up properly before running
echo "is stuff set up properly? (press anything to continue, or break to quit)"
read YES

# test ssh connection
ssh -T git@github.com

# get fonts
sudo apt install fonts-firacode

curl -o jbmono.zip -L "https://download.jetbrains.com/fonts/JetBrainsMono-1.0.0.zip"
unzip jbmono.zip -d "$HOME/.fonts"
rm -f jbmono.zip
sudo fc-cache -f -v

# add the alias
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

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

# copy example env
cp $HOME/.env.example $HOME/.env

# make sure to configure dotfiles repo to not show untracked files
dot config --local status.showUntrackedFiles no

# source the added files
source $HOME/.bash_profile

echo "general setup done."
echo ""

# -- install some convenient stuff
echo "continue installing extra stuff? (press anything to continue, or break to quit)"
read YES

# nvm
# NVM_DIR already set in .path
git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
. "$NVM_DIR/nvm.sh"
nvm install node
