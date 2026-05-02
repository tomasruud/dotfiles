export EDITOR="hx"
export VISUAL="hx"
export PAGER="bat"

export MANWIDTH=80

export XDG_CONFIG_HOME="$HOME/.config"

export LC_ALL="en_US.UTF-8"

if [ -e "$HOME/.env" ]; then
  source "$HOME/.env"
else
  echo "** Notice: no .env file loaded"
fi
