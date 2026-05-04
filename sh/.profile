export EDITOR="hx"
export VISUAL="hx"
export PAGER="less"

export MANWIDTH=80

export XDG_CONFIG_HOME="$HOME/.config"

export LC_ALL="en_US.UTF-8"

# --- Paths
PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"

# --- Docker
if [ -d "$HOME/.docker/bin" ]; then
  PATH="$HOME/.docker/bin:$PATH"
fi

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
if [ -d /opt/homebrew/opt/go/libexec ]; then
  export GOROOT=/opt/homebrew/opt/go/libexec
elif [ -d /usr/local/go ]; then
  PATH="/usr/local/go/bin:$PATH"
fi

if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/go"
  PATH="$GOPATH/bin:$PATH"
fi

# --- Rust
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

# --- Node
if [ -d "$HOME/.npm-global" ]; then
  export NPM_CONFIG_GLOBALCONFIG="$HOME/.config/node/.npmrc"
  PATH="$HOME/.npm-global/bin:$PATH"
fi

# --- Ruby
if [ -d /opt/homebrew/opt/ruby ]; then
  PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

if command -v ruby >/dev/null 2>&1; then
  export GEM_HOME="$HOME/.gems"
  PATH="$HOME/.gems/bin:$PATH"
fi

# --- PHP
if [ -d "$HOME/.composer/vendor/bin" ]; then
  PATH="$HOME/.composer/vendor/bin:$PATH"
fi

# --- JetBrains
if [ -d /opt/jetbrains/bin ]; then
  PATH="/opt/jetbrains/bin:$PATH"
fi

# --- usql
if command -v usql >/dev/null 2>&1; then
  export USQL_CONFIG="$HOME/.config/usql/config.yaml"
fi

# --- Janet
if [ -d /opt/homebrew/opt/janet ]; then
  PATH="/opt/homebrew/opt/janet/bin:$PATH"
fi

export PATH

if [ -e "$HOME/.env" ]; then
  source "$HOME/.env"
else
  echo "** Notice: no .env file loaded"
fi
