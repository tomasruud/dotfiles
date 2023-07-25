setopt globdots

autoload -Uz compinit; compinit

zstyle ':completion:*' menu select

PROMPT='%~$(gitprompt)\$ '

alias gti="git"
alias got="git"
alias cat="bat"
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls --color=auto"
alias ll="ls -alF"
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
alias gl="goland ."
alias ws="webstorm ."
alias f="open ."
