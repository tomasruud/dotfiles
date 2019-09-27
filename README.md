# Dotfiles

Using setup from https://www.atlassian.com/git/tutorials/dotfiles
Heavy inspiration from https://github.com/jessfraz/dotfiles

## Initialize
```
git init --bare $HOME/.cfg
touch $HOME/.config/git/config
source $HOME/.bash_profile
config config --local core.excludesfile $HOME/.configignore
```
