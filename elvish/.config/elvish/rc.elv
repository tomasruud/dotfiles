use os

# --- Global config
set-env LC_ALL en_US.UTF-8

if (os:exists ~/.env.elv) {
	eval (slurp < ~/.env.elv)
} else {
	echo (styled "[note]" bold red) "No .env file loaded."
}

set-env EDITOR hx
set-env VISUAL hx
set-env PAGER bat

set-env XDG_CONFIG_HOME ~/.config

set paths = [
	~/bin
	~/.local/bin
	/usr/local/bin
	/usr/bin
	/usr/sbin
	/bin
]

# --- Man
set-env MANWIDTH 80

# --- Docker
if (os:exists ~/.docker/bin) {
	set paths = [~/.docker/bin $@paths]
}

# --- Homebrew
if (os:exists /opt/homebrew) {
	set-env HOMEBREW_PREFIX /opt/homebrew
	set-env HOMEBREW_CELLAR /opt/homebrew/Cellar
	set-env HOMEBREW_REPOSITORY /opt/homebrew
	set-env MANPATH /opt/homebrew/share/man:$E:MANPATH
	set-env INFOPATH /opt/homebrew/share/info:$E:INFOPATH

	set paths = [
		/opt/homebrew/bin
		/opt/homebrew/sbin
		$@paths
	]
}

# --- Helix
if (os:exists ~/external/helix/runtime) {
    set-env HELIX_RUNTIME ~/external/helix/runtime
}

# --- Go
if (os:exists /opt/homebrew/opt/go/libexec) {
	set-env GOROOT /opt/homebrew/opt/go/libexec
} elif (os:exists /usr/local/go) {
	set paths = [/usr/local/go/bin $@paths]
}

if (has-external go) {
	set-env GOPATH ~/go
	set paths = [$E:GOPATH/bin $@paths]
}

# --- Rust
if (os:exists ~/.cargo/bin) {
	set paths = [~/.cargo/bin $@paths]
}

# --- Node
if (os:exists ~/.npm-global) {
	set paths = [~/.npm-global/bin $@paths]
}

# --- Ruby
if (os:exists /opt/homebrew/opt/ruby) {
	set paths = [/opt/homebrew/opt/ruby/bin $@paths]
}

if (has-external ruby) {
	# Customizing the gem folder makes it possible to use without sudo.
	set-env GEM_HOME ~/.gems
	set paths = [~/.gems/bin $@paths]
}

# --- PHP
if (os:exists ~/.composer/vendor/bin) {
	set paths = [~/.composer/vendor/bin $@paths]
}

# --- JetBrains
if (os:exists /opt/jetbrains/bin) {
	set paths = [/opt/jetbrains/bin $@paths]
}

# --- usql
if (has-external usql) {
	set-env USQL_CONFIG ~/.config/usql/config.yaml
}

# --- Functions
fn home {|| cd ~}
fn note {|| hx ~/notes.txt}
fn .. {|| cd ..}

fn jwt {|in| use str; echo [(str:split '.' $in)][1] | base64 -D }

fn ll {|@a|
	if (has-external eza) {
		e:eza --group-directories-first -alF $@a
	} else {
		echo (styled "[note]" bold blue) "eza is not installed, falling back to ls"
		ls -alF $@a
	}
}

fn lt {|@a|
	if (has-external eza) {
		e:eza --group-directories-first --tree --git-ignore --ignore-glob vendor $@a
	} else {
		echo (styled "[note]" bold blue) "eza is not installed, falling back to tree"
		tree --dirsfirst $@a
	}
}

# --- Abbrs
set edit:command-abbr['gti'] = 'git'
set edit:command-abbr['got'] = 'git'
set edit:command-abbr['d'] = 'docker compose run --rm'
set edit:command-abbr['dc'] = 'docker compose'
set edit:command-abbr['dx'] = 'docker run --rm --interactive --tty --volume (pwd):/app --workdir /app'
set edit:command-abbr['gt'] = 'gotestsum'
set edit:command-abbr['dd'] = 'docker desktop'

# --- Elvish keybinds
set edit:insert:binding[Ctrl-N] = { edit:end-of-history }
set edit:insert:binding[Ctrl-P] = { edit:history:start }
set edit:insert:binding[Ctrl-B] = { edit:move-dot-left }
set edit:insert:binding[Ctrl-F] = { edit:move-dot-right }
set edit:insert:binding[Ctrl-A] = { edit:move-dot-sol }
set edit:insert:binding[Ctrl-E] = { edit:move-dot-eol }
set edit:insert:binding[Ctrl-D] = {
  if (> (count $edit:current-command) 0) {
    edit:kill-rune-right
  } else {
	  edit:return-eof
  }
}
set edit:insert:binding[Ctrl-T] = { edit:navigation:start }

set edit:completion:binding[Ctrl-N] = { edit:completion:down }
set edit:completion:binding[Ctrl-P] = { edit:completion:up }
set edit:completion:binding[Ctrl-B] = { edit:completion:left }
set edit:completion:binding[Ctrl-F] = { edit:completion:right }

set edit:navigation:binding[h] = { edit:navigation:left }
set edit:navigation:binding[j] = { edit:navigation:down }
set edit:navigation:binding[k] = { edit:navigation:up }
set edit:navigation:binding[l] = { edit:navigation:right }
set edit:navigation:binding[Ctrl-N] = { edit:navigation:page-down }
set edit:navigation:binding[Ctrl-P] = { edit:navigation:page-up }
set edit:navigation:binding[Ctrl-D] = { edit:navigation:file-preview-down }
set edit:navigation:binding[Ctrl-U] = { edit:navigation:file-preview-up }

set edit:history:binding[Ctrl-N] = { edit:history:down-or-quit }
set edit:history:binding[Ctrl-P] = { edit:history:up }

set edit:listing:binding[Ctrl-N] = { edit:listing:down }
set edit:listing:binding[Ctrl-P] = { edit:listing:up }

# --- Prompt
if (has-external tprompt) {
	set edit:prompt = { tprompt -left }
	set edit:rprompt = { tprompt -right }
}

# --- Completions
if (has-external carapace) {
	set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
	fn carapace {|@a| env NO_COLOR=1 carapace $@a }
  eval (carapace _carapace | slurp)
} else {
	echo (styled "[note]" bold red) "Carapace is not installed, completions are not enabled."
}
