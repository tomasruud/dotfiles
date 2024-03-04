use os

# --- Global config
set-env LC_ALL en_US.UTF-8

if (os:exists ~/.env.elv) {
	eval (slurp < ~/.env.elv)
} else {
	echo (styled "No .env file loaded." red)
}

set paths = [
	/usr/local/bin
	/usr/bin
	/bin
]

# --- Nix
if (os:exists /nix/var/nix/profiles/default/bin) {
	set paths = [
		~/.nix-profile/bin
		/nix/var/nix/profiles/default/bin
		$@paths
	]
} else {
	echo (styled "Nix is not installed or incorrectly configured" red)
}

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
	set-env GOROOT opt/homebrew/opt/go/libexec
}

if (os:exists /usr/local/go) {
	set paths = [/usr/local/go/bin $@paths]
}

if (has-external go) {
	set-env GOPATH ~/go
	set paths = [~/go/bin $@paths]
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
		ls -alF $@a
	}
}

fn lt { |@a|
	if (has-external eza) {
		e:eza --group-directories-first --tree --git-ignore --ignore-glob vendor $@a
	} else {
		tree --gitignore $@a
	}
}

# --- Abbrs
set edit:command-abbr['gti'] = 'git'
set edit:command-abbr['got'] = 'git'
set edit:command-abbr['d'] = 'docker compose run --rm'
set edit:command-abbr['dc'] = 'docker compose'
set edit:command-abbr['dx'] = 'docker run --rm --interactive --tty --volume (pwd):/app --workdir /app'
