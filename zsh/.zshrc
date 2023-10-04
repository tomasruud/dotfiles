# allows for matching dotfiles
setopt globdots

autoload -Uz compinit; compinit

zstyle ':completion:*' menu select

# prompt style
PROMPT='%~$(gitprompt)\$ '

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

# work related aliases
alias axp="(cd $HOME/work/a2755 && fd '.git$' --prune -u -t d --strip-cwd-prefix -x echo {//}) | fzf | xargs -I {} echo $HOME/work/a2755/{}"
alias axpc="cd \$(axp)"
alias axpw="tmux new-window -c \$(axp)"
alias axph="hx \$(axp)"