# dotfiles

## OSX
### Install
1. Copy the `.env.example` file and put it in `$HOME/.env`.
1. Install xcode command line tools. Homebrew might try to install this for you.
1. Install homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
1. Clone the repo `git clone git@github.com:tomasruud/dotfiles.git $HOME/dotfiles`
1. Install the dotfiles `$HOME/dotfiles/install-osx.sh`
1. Install homebrew bundle `brew bundle --file ~/Brewfile`

### Backup secrets
Run `$HOME/dotfiles/backup-secrets.sh` to make a compressed archive with secret files.