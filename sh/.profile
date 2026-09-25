export EDITOR="hx"
export VISUAL="hx"
export PAGER="less"

export MANWIDTH=80

export XDG_CONFIG_HOME="$HOME/.config"

export LC_ALL="en_US.UTF-8"

# --- Paths
PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"

# --- Docker
PATH="$HOME/.docker/bin:$PATH"

# --- Garmin
if [ -f "$HOME/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg" ]; then
  PATH="$(cat "$HOME/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg")/bin:$PATH"
fi

# --- Homebrew
if [ -d /opt/homebrew ]; then
  export HOMEBREW_PREFIX=/opt/homebrew
  export HOMEBREW_CELLAR=/opt/homebrew/Cellar
  export HOMEBREW_REPOSITORY=/opt/homebrew
  export MANPATH="/opt/homebrew/share/man:$MANPATH"
  export INFOPATH="/opt/homebrew/share/info:$INFOPATH"
  PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# --- Go
export GOPATH="$HOME/go"
PATH="/usr/local/go/bin:$PATH"
PATH="$GOPATH/bin:$PATH"

# --- Rust
PATH="$HOME/.cargo/bin:$PATH"

# --- Node
export NPM_CONFIG_GLOBALCONFIG="$HOME/.config/node/.npmrc"
PATH="$HOME/.npm-global/bin:$PATH"

# --- Ruby
export GEM_HOME="$HOME/.gems"
PATH="/opt/homebrew/opt/ruby/bin:$PATH"
PATH="$HOME/.gems/bin:$PATH"

# --- PHP
PATH="$HOME/.composer/vendor/bin:$PATH"

# --- Janet
export JANET_PROFILE="$HOME/.config/janet/profile.janet"
PATH="/opt/homebrew/opt/janet/bin:$PATH"

export PATH

if [ -e "$HOME/.env" ]; then
  . "$HOME/.env"
else
  echo "** Notice: no .env file loaded" 1>&2
fi
