source "$HOME/.bashrc"

for file in ~/.{env,aliases,path,iterm}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file