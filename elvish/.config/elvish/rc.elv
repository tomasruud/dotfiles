use os

# -- System
set-env LC_ALL "en_US.UTF-8"

set paths = [
	/usr/bin
	/bin
]

# --- User
if (os:exists "~/.local/bin") {
	set paths = [~/.local/bin $@paths]
}

# --- Man
set-env MANWIDTH 80

# --- Homebrew
if (os:exists "/opt/homebrew") {
	set-env HOMEBREW_PREFIX "/opt/homebrew"
	set-env HOMEBREW_CELLAR "/opt/homebrew/Cellar"
	set-env HOMEBREW_REPOSITORY "/opt/homebrew"
	set-env MANPATH "/opt/homebrew/share/man:"$E:MANPATH
	set-env INFOPATH "/opt/homebrew/share/info:"$E:INFOPATH

	set paths = [
		/opt/homebrew/bin
		/opt/homebrew/sbin
		$@paths
	]
}

# --- Go
if (os:exists "/opt/homebrew/opt/go/libexec") {
	set-env GOROOT "opt/homebrew/opt/go/libexec"
}

if (os:exists "/usr/local/go") {
	set paths = [/usr/local/go/bin $@paths]
}

if (has-external go) {
	set-env GOPATH "~/go"
	set paths = [~/go/bin $@paths]
}

# --- Aliases
fn ll {|@a| eza --group-directories-first -al $@a}
fn lt {|@a| eza --group-directories-first --tree --git-ignore --ignore-glob vendor $@a}
fn gti {|@a| git $@a}
fn got {|@a| git $@a}
