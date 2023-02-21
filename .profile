function do_if_exists() {
    local loc="$1"
    shift
    local do="$@"

    if [[ -e "$loc" ]]; then
        eval "$do"
    fi
}

function decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'=' 
  fi
  echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}

function decode_jwt(){
   decode_base64_url $(echo -n $2 | cut -d "." -f $1)
}

# --- load env
do_if_exists "$HOME/.env" 'source "$HOME/.env"'

# --- aliases
alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias gti="git"
alias got="git"
alias cat="bat"
alias ..="cd .."
alias ...="cd ../.."
alias ll='ls -alF'
alias dc="docker compose"
alias d="dc run --rm"
alias dx="docker run --rm --interactive --tty --volume $PWD:/app --workdir /app"
alias ds="dc run --service-ports --rm"
alias sail="bash vendor/bin/sail"
alias work="cd $HOME/work"
alias projects="cd $HOME/projects"
alias home="cd $HOME"
alias deployer="vendor/bin/dep"
alias nv="nvim"
alias remote-ip="curl https://icanhazip.com"
alias dot-backup="tar -zcvf dotfile-backup.tar.gz $HOME/.ssh $HOME/.netrc $HOME/.env"
alias jwt="decode_jwt 2"
alias gl="goland ."
alias ws="webstorm ."
alias f="open ."

# --- path entries
do_if_exists "/opt/homebrew/bin/brew" 'eval "$(/opt/homebrew/bin/brew shellenv)"'
do_if_exists "/opt/homebrew/opt/go/libexec" 'export GOROOT="/opt/homebrew/opt/go/libexec"'
do_if_exists "$HOME/.cargo/bin" 'export PATH="$PATH:$HOME/.cargo/bin"'
do_if_exists "$HOME/.bin" 'export PATH="$HOME/.bin:$PATH"'
do_if_exists "$HOME/go/bin" 'export PATH="$HOME/go/bin:$PATH"'
do_if_exists "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" 'export PATH="$PATH:`cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg`/bin"'
do_if_exists "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" 'export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"'
