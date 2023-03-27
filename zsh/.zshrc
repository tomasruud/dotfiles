export PS1="%~ git:$(git status 2> /dev/null | grep "nothing to commit" >/dev/null 2>&1 || echo "+")"$'\n'"$ "
