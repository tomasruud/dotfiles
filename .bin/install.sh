#!/bin/bash
# most of these steps are from the guide at 
# https://www.atlassian.com/git/tutorials/dotfiles

# add the alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# add a dummy gitignore
echo ".cfg" >> .gitignore

# clone the repo
git clone --bare git@github.com:tomasruud/dot.git $HOME/.cfg

# checkout code and try to move conflicting files automatically
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}

# do the checkout again if it failed previously
config checkout

# create separate git config
touch $HOME/.config/git/config

# copy example env
cp $HOME/.env.example $HOME/.env

# make sure to use provided configignore file
config config --local core.excludesfile $HOME/.configignore

# source the added files
source $HOME/.bash_profile
