source "$HOME/.env"
PATH="$HOME/bin:$PATH"

if [[ -e "$HOME/.config/zsh/plugins" ]]; then
    find "$HOME/.config/zsh/plugins" -path "*" -name "*.plugin.zsh" | while read plugin; do
        source "$plugin"
    done
fi

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

if [[ -e "$HOME/.Garmin/ConnectIQ/current-sdk.cfg" ]]; then
	PATH="$PATH:`cat $HOME/.Garmin/ConnectIQ/current-sdk.cfg`/bin"
fi

if [[ -e "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
	PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

if [[ -e "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin" ]]; then
	PATH="$PATH:$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fi

if [[ -e "$HOME/.opam/opam-init/init.zsh" ]]; then
    source "$HOME/.opam/opam-init/init.zsh"
fi

