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

linkdotfile bash/.functions .functions
linkdotfile bash/.inputrc .inputrc
linkdotfile bash/.profile .profile
linkdotfile brew/Brewfile Brewfile
linkdotfile git/.gitconfig .gitconfig
linkdotfile git/.githooks .githooks
linkdotfile git/.gitignore .gitignore
linkdotfile osx/.hushlogin .hushlogin
linkdotfile warp .warp
linkdotfile zsh/.zprofile .zprofile
