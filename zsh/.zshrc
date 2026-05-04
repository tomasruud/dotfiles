# Carapace
if command -v carapace >/dev/null 2>&1; then
  autoload -U compinit && compinit
  zstyle ':completion:*' format $'Completing %d'
  source <(carapace _carapace)
fi

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
fi

# Prompt
setopt PROMPT_SUBST
RPROMPT='$([ $? -gt 0 ] && echo ">:(")'

if command -v tprompt >/dev/null 2>&1; then
  function precmd() {
    PROMPT='$(tprompt)'
  }
fi

# Zellij
if [[ -v ZELLIJ ]]; then
  function _setup_zellij() {
    current=$(zellij action current-tab-info -j | jq -r ".name")

    if [[ $current == "Tab "* ]]; then
      words=("${(f)$(</usr/share/dict/words)}")
      zellij action rename-tab $words[RANDOM%${#words[@]}+1]
    fi

    function _zellij-pwd {
      zellij action rename-pane $(pwd | tprompt path --width 80)
    }

    _zellij-pwd

    function chpwd() {
      _zellij-pwd
    }

    add-zsh-hook -d precmd _setup_zellij
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _setup_zellij
fi

# FZF history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY     # save timestamp + duration with each entry
setopt HIST_IGNORE_SPACE    # don't record commands starting with a space
setopt HIST_IGNORE_ALL_DUPS # if a new cmd duplicates an older one, drop the older
setopt HIST_REDUCE_BLANKS   # trim superfluous whitespace before saving
setopt HIST_VERIFY          # when expanding !!, show the expansion before running
setopt INC_APPEND_HISTORY   # append to HISTFILE as commands run, not at exit
setopt SHARE_HISTORY        # share history live across all open shells

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Aliases
alias gg="go generate ./..."
alias gt="gotestsum"
