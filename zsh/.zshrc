# autocompletion
autoload -U compinit; compinit

# git related
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b'

# prompt style
export PROMPT='%~$ '
