# Local env
source "$HOME/.env"

# User binaries
if [[ -e "$HOME/.local/bin" ]]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# Zsh
if [[ -e "$HOME/.config/zsh/plugins" ]]; then
    find "$HOME/.config/zsh/plugins" -path "*" -name "*.plugin.zsh" | while read plugin; do
        source "$plugin"
    done
fi

# Homebrew
if [[ -e "/opt/homebrew/bin/brew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Golang
if [[ -e "/opt/homebrew/opt/go/libexec" ]]; then
	GOROOT="/opt/homebrew/opt/go/libexec"
fi

if [[ -e "/usr/local/go" ]]; then
	PATH="$PATH:/usr/local/go/bin"
fi

GOPATH="$HOME/go"
PATH="$PATH:$GOPATH/bin"

# Ruby
if [[ -e "/opt/homebrew/opt/ruby" ]]; then
	PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

if command -v "ruby" > /dev/null 2>&1; then
	GEMSDIR=$(gem environment gemdir)/bin
	PATH="$PATH:$GEMSDIR"
fi

# Rust
if [[ -e "$HOME/.cargo/bin" ]]; then
	PATH="$PATH:$HOME/.cargo/bin"
fi

if [[ -e "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Garmin Connect SDK
if [[ -e "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" ]]; then
	PATH="$PATH:`cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg`/bin"
fi

# JetBrains toolbox
if [[ -e "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
	PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# Sublime text
if [[ -e "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin" ]]; then
	PATH="$PATH:$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fi

# OCaml
if [[ -e "$HOME/.opam/opam-init/init.zsh" ]]; then
	source "$HOME/.opam/opam-init/init.zsh"
fi

# Lisp
if [[ -e "$HOME/.ghcup/env" ]]; then
	source "$HOME/.ghcup/env"
fi


# Node
if [[ -e "$HOME/.npm-global/bin" ]]; then
	PATH="$PATH:$HOME/.npm-global/bin"
fi

if [[ -e "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
	source "/opt/homebrew/opt/nvm/nvm.sh"
fi

