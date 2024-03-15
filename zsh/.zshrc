# allows for matching dotfiles
setopt globdots

# set man pages max width
export MANWIDTH=80

# prompt style
setopt PROMPT_SUBST
PROMPT='$(tprompt -left)'
RPROMPT='$(tprompt -right)'

# register completions
autoload -Uz compinit; compinit

if command -v "carapace" > /dev/null 2>&1; then
  alias carapace="NO_COLOR=1 carapace"
  source <(carapace _carapace)
else
  zstyle ':completion:*' menu select
fi

# function that locates git repos within a root folder
function fzfproj() {
  if [ -z "$1" ]; then
    echo "folder argument must be provided"
    return 1
  fi
  
  project=$(cd "$1" && fd '.git$' --strip-cwd-prefix --prune -u -t d -x echo {//} | fzf --query="$2" --reverse --height=10)

  if [ -z "$project" ]; then
    return 1
  fi
  
  echo "$1/$project"
}

# function for killing specific port
function killport() {
  if [ -z "$1" ]; then
    echo "port agrument must be provided"
    return 1
  fi

  lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill
}

# function for queueing YouTube stuff
function qyt() {
  (cd $HOME/qyt && yt-dlp "$1")
}

# aliases
alias dot="./dot"
alias gti="git"
alias got="git"
alias ..="cd .."
alias ...="cd ../.."
alias eza="eza --group-directories-first"
alias lt="eza --tree --git-ignore --ignore-glob vendor"
alias ll="eza -alF"
alias dc="docker compose"
alias d="dc run --rm"
alias dx="docker run --rm --interactive --tty --volume $PWD:/app --workdir /app"
alias ds="dc run --service-ports --rm"
alias work="cd $HOME/work"
alias projects="cd $HOME/projects"
alias home="cd $HOME"
alias deployer="vendor/bin/dep"
alias nv="nvim"
alias remote-ip="curl https://icanhazip.com"
alias gl="goland ."
alias ws="webstorm ."
alias f="open ."
alias note="hx ~/notes.txt"
alias notes="note"
alias yt="yt-dlp"
alias todos="rg TODO"

alias pr="cd \$(fzfproj $HOME/projects || pwd)"
alias axo="cd \$(fzfproj $HOME/work/a2755 || pwd)"
