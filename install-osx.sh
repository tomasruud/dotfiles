function linkdotfile {
  root="$HOME/dot"
  from="$1"
  to="$2"
  if [ ! -e "$HOME/$to" -a ! -L "$HOME/$to" ]; then
      echo "$to not found, linking to $root/$from..." >&2
      ln -s "$root/$from" "$HOME/$to"
  else
      echo "$to found, ignoring..." >&2
  fi
}

linkdotfile warp .warp
linkdotfile git/.gitconfig .gitconfig
linkdotfile git/.githooks .githooks
linkdotfile git/.gitignore .gitignore
linkdotfile shell/.functions .functions
linkdotfile shell/.hushlogin .hushlogin
linkdotfile shell/.inputrc .inputrc
linkdotfile shell/.profile .profile
linkdotfile shell/.zprofile .zprofile
linkdotfile brew/Brewfile Brewfile
