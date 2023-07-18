function zplugin() {
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

zplugin git-prompt https://github.com/woefe/git-prompt.zsh.git v2.3.0
zplugin zsh-completions https://github.com/zsh-users/zsh-completions.git 0.34.0
zplugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git v0.7.0

autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _list _complete _expand _oldlist

export PROMPT='%~$(gitprompt)\$ '
