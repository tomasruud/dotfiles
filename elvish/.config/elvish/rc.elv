use dot
use os

# --- Elvish keybinds
use readline-binding

# --- Global config
set-env LC_ALL en_US.UTF-8

if (os:exists ~/.env.elv) {
	eval (slurp < ~/.env.elv)
} else {
	echo (styled "[note]" bold red) "No .env file loaded."
}

set-env EDITOR hx

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

# --- Ruby
if (os:exists /opt/homebrew/opt/ruby) {
	set paths = [/opt/homebrew/opt/ruby/bin $@paths]
}

if (has-external ruby) {
	# Customizing the gem folder makes it possible to use without sudo.
	set-env GEM_HOME ~/.gems
	set paths = [~/.gems/bin $@paths]
}

# --- Functions
fn home {|| cd ~}
fn note {|| hx ~/notes.txt}

fn jwt {|in| use str; echo [(str:split '.' $in)][1] | base64 -D }
fn o {|| use utils; utils:open-url (slurp) }

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

# --- Prompt
set edit:prompt = { tprompt -left }
set edit:rprompt = { tprompt -right }

# --- Completions
if (has-external carapace) {
	set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
	fn carapace {|@a| env NO_COLOR=1 carapace $@a }
  eval (carapace _carapace | slurp)
} else {
	echo (styled "[note]" bold red) "Carapace is not installed, completions are not enabled."
}
