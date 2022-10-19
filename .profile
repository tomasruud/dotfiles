# --- load env
[[ -e "$HOME/.env" ]] && source "$HOME/.env" || echo "Seems like you don't have .env set up"

# --- aliases
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias gti="git"
alias got="git"
alias ..="cd .."
alias ...="cd ../.."
alias ll='ls -alF'
alias dc="docker-compose"
alias d="dc run --rm"
alias dx="docker run --rm --interactive --tty --volume $PWD:/app --workdir /app"
alias ds="dc run --service-ports --rm"
alias sail="bash vendor/bin/sail"
alias work="cd $HOME/work"
alias projects="cd $HOME/projects"
alias deployer="vendor/bin/deployer.phar"
alias nv="nvim"
alias remote-ip="curl https://icanhazip.com"
alias dot-backup="tar -zcvf dotfile-backup.tar.gz $HOME/.ssh $HOME/.netrc $HOME/.env"

# --- path entries
[[ -e "$HOME/.bin" ]] && export PATH="$HOME/.bin:$PATH"
[[ -e "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" ]] && export PATH=$PATH:`cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg`/bin
[[ -e "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]] && export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
[[ -e "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -e "$HOME/.cargo/bin" ]] && export PATH="$PATH:$HOME/.cargo/bin"
