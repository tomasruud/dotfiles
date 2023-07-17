function zsh-plugin() {
	local root="$HOME/.zsh/plugins"

	local name="$1"
	local repo="$2"
	local version="$3"

	local plugin="$root/$name"

	if [[ ! -d "$plugin" ]]; then
		echo "zsh plugin $name not found, cloning it from $repo"
		git clone -b "$version" "$repo" "$plugin"
	fi

	source "$plugin/$name.plugin.zsh"
}

zsh-plugin git-prompt https://github.com/woefe/git-prompt.zsh.git v2.3.0
zsh-plugin zsh-completions https://github.com/zsh-users/zsh-completions.git 0.34.0
zsh-plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git v0.7.0

autoload -Uz compinit
compinit

export PROMPT='%~$(gitprompt)\$ '
