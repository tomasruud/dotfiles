# allows for matching dotfiles
setopt globdots

autoload -Uz compinit; compinit

zstyle ':completion:*' menu select

# prompt style
PROMPT='%1~$(gitprompt)\$ '

# function that locates git repos within a root folder
function fzfproj() {
  if [ -z "$1" ]; then
    echo "folder argument must be provided"
    return 1
  fi
  
  project=$(cd "$1" && fd '.git$' --strip-cwd-prefix --prune -u -t d -x echo {//} | fzf --query="$2")

  if [ -z "$project" ]; then
    return 1
  fi
  
  echo "$1/$project"
}

function killport() {
  if [ -z "$1" ]; then
    echo "port agrument must be provided"
    return 1
  fi

  lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill
}

# aliases
alias dot="./dot"
alias gti="git"
alias got="git"
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -alF"
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
alias exa="exa --group-directories-first"
alias lt="exa --tree"

alias pr="cd \$(fzfproj $HOME/projects || pwd)"
alias axpc="cd \$(fzfproj $HOME/work/a2755 || pwd)"
alias axpw="fzfproj $HOME/work/a2755 | xargs -I {} tmux new-window -c {}"
alias axph="fzfproj $HOME/work/a2755 | xargs -I {} hx {}"