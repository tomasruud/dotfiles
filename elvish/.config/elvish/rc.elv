use os

# --- Global config
use readline-binding

if (os:exists ~/.env.elv) {
	eval (slurp < ~/.env.elv)
} else {
	echo (styled "[note]" bold red) "No .env file loaded."
}

set paths = [
	~/bin
	~/.local/bin
	/usr/local/bin
	/usr/bin
	/usr/sbin
	/bin
	/sbin
]

# --- Docker
if (os:exists ~/.docker/bin) {
	set paths = [~/.docker/bin $@paths]
}

# --- Garmin
if (os:exists ~'/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg') {
    set paths = [(cat ~'/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg')/bin $@paths]
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
	set-env NPM_CONFIG_GLOBALCONFIG ~/.config/node/.npmrc

	set paths = [
    ~/.npm-global/bin
    $@paths
  ]
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

# --- Janet
if (os:exists /opt/homebrew/opt/janet) {
	set paths = [
    /opt/homebrew/opt/janet/bin
    $@paths
  ]
}

# --- Functions
fn gg {|| go generate ./... }
fn gt {|| gotestsum }

fn notify {|msg|
    if (has-external terminal-notifier) {
        terminal-notifier -title "Terminal" -message $msg -sound default
    } else {
        echo (styled "terminal-notifier is not installed, can not send notification." red)
    }
}

# --- Abbrs
set edit:command-abbr['gti'] = 'git'
set edit:command-abbr['got'] = 'git'
set edit:command-abbr['d'] = 'docker compose run --rm'
set edit:command-abbr['dc'] = 'docker compose'
set edit:command-abbr['dx'] = 'docker run --rm --interactive --tty --volume (pwd):/app --workdir /app'
set edit:command-abbr['dd'] = 'docker desktop'

# --- Prompt
if (has-external tprompt) {
	set edit:prompt = { tprompt }
	set edit:rprompt = { tprompt remote }
}

# --- Completions
if (has-external carapace) {
  eval (carapace _carapace | slurp)
} else {
	echo (styled "[note]" bold red) "Carapace is not installed, completions are not enabled."
}

# --- Zoxide
if (has-external zoxide) {
  set-env _ZO_EXCLUDE_DIRS "$HOME:/tmp/*:/private/*"
  eval (zoxide init --cmd j elvish | slurp)
}

# --- Zellij
if (has-env ZELLIJ) {
  fn _zellij-name-pane {||
    var current = (zellij action current-tab-info -j | jq -r ".name")

    use str
    if (str:has-prefix $current "Tab ") {
      var words = [(cat /usr/share/dict/words | from-lines)]
      zellij action rename-tab $words[(randint (count $words))]
    }
  }

  _zellij-name-pane

  fn _zellij-pwd {|@_| zellij action rename-pane (pwd | tprompt path --width 80) }

  _zellij-pwd

  set after-chdir = [
    $@after-chdir
    $_zellij-pwd~
  ]
}
