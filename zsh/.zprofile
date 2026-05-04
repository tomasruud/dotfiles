if [ -f ~/.profile ]; then
  emulate sh -c '. ~/.profile'
fi

export _ZO_EXCLUDE_DIRS="$HOME:/tmp/*:/private/*"
