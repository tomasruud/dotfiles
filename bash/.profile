# --- load bootstrap files
if [[ -e "$HOME/.env" ]]; then 
	source "$HOME/.env"
fi

if [[ -e "$HOME/.functions" ]]; then
	source "$HOME/.functions"
fi

# --- aliases
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

# --- path entries and such
if [[ -e "/opt/homebrew/bin/brew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -e "/opt/homebrew/opt/go/libexec" ]]; then
	GOROOT="/opt/homebrew/opt/go/libexec"
	GOPATH="$HOME/go"
	PATH="$GOPATH/bin:$PATH"
fi

if [[ -e "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
	source "/opt/homebrew/opt/nvm/nvm.sh"
fi

if [[ -e "/opt/homebrew/opt/ruby" ]]; then
	PATH="/opt/homebrew/opt/ruby/bin:$PATH"
	GEMSDIR=$(gem environment gemdir)/bin
	PATH="$PATH:$GEMSDIR"
fi

if [[ -e "$HOME/.cargo/bin" ]]; then
	PATH="$PATH:$HOME/.cargo/bin"
fi

if [[ -e "$HOME/.bin" ]]; then
	PATH="$HOME/.bin:$PATH"
fi

if [[ -e "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" ]]; then
	PATH="$PATH:`cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg`/bin"
fi

if [[ -e "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
	PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

if [[ -e "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin" ]]; then
	PATH="$PATH:$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fi
