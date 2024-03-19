use os

# --- Global config
set-env LC_ALL en_US.UTF-8

if (os:exists ~/.env.elv) {
	eval (slurp < ~/.env.elv)
} else {
	echo (styled "[note]" bold red) "No .env file loaded."
}

set paths = [
	/usr/local/bin
	/usr/bin
	/bin
]

# --- User
if (os:exists ~/.local/bin) {
	set paths = [~/.local/bin $@paths]
}

# --- Man
set-env MANWIDTH 80

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

# --- Go
if (os:exists /opt/homebrew/opt/go/libexec) {
	set-env GOROOT /opt/homebrew/opt/go/libexec
}

if (os:exists /usr/local/go) {
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

# --- Ruby
if (os:exists /opt/homebrew/opt/ruby) {
	set paths = [/opt/homebrew/opt/ruby/bin $@paths]
}

if (has-external ruby) {
	var gems = (gem environment gemdir)/bin
	var usr-gems = (ruby -e 'print Gem.user_dir')/bin
	set paths = [$usr-gems $gems $@paths]
}

# --- Functions
fn reload {|| eval (slurp < ~/.config/elvish/rc.elv)}
fn home {|| cd ~}
fn note {|| hx ~/notes.txt}

fn ll { |@a|
	if (has-external eza) {
		e:eza --group-directories-first -alF $@a
	} else {
		echo (styled "[note]" bold blue) "eza is not installed, falling back to ls"
		ls -alF $@a
	}
}

fn lt { |@a|
	if (has-external eza) {
		e:eza --group-directories-first --tree --git-ignore --ignore-glob vendor $@a
	} else {
		echo (styled "[note]" bold blue) "eza is not installed, falling back to tree"
		tree --gitignore $@a
	}
}

# --- Abbrs
set edit:command-abbr['gti'] = 'git'
set edit:command-abbr['got'] = 'git'
set edit:command-abbr['d'] = 'docker compose run --rm'
set edit:command-abbr['dc'] = 'docker compose'
set edit:command-abbr['dx'] = 'docker run --rm --interactive --tty --volume (pwd):/app --workdir /app'

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

set edit:navigation:binding[Ctrl-B] = { edit:navigation:left }
set edit:navigation:binding[Ctrl-F] = { edit:navigation:right }
set edit:navigation:binding[Ctrl-N] = { edit:navigation:down }
set edit:navigation:binding[Ctrl-P] = { edit:navigation:up }

set edit:history:binding[Ctrl-N] = { edit:history:down-or-quit }
set edit:history:binding[Ctrl-P] = { edit:history:up }

set edit:listing:binding[Ctrl-N] = { edit:listing:down }
set edit:listing:binding[Ctrl-P] = { edit:listing:up }

# TODO: figure out some fun binding for deleting dumb entries
set edit:histlist:binding[Meta-0] = {|a| put $a }

# --- Prompt
set edit:prompt = { tprompt -left }
set edit:rprompt = { tprompt -right }

# --- Completions
if (has-external carapace) {
	fn carapace {|@a| env NO_COLOR=1 carapace $@a }
  eval (carapace _carapace | slurp)
} else {
	echo (styled "[note]" bold red) "Carapace is not installed, completions are not enabled."
}
