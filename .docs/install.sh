#!/bin/bash
# most of these steps are from the guide at 
# https://www.atlassian.com/git/tutorials/dotfiles
#
# if on a brand new install, use setup.sh first

# test ssh connection
ssh -T git@github.com

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

