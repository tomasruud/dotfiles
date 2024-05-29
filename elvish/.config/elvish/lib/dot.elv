# Commands for managing dotfiles

# Install or sync current files
fn sync {
  if (not (has-external stow)) {
    fail 'You must install GNU stow to continue...'
  }

  use utils
  utils:do-in-dir ~/dotfiles {
    var target = ~
    stow --verbose --target=$target --restow */
  }
}

# Removes all symlinks
fn uninstall {
  if (not (has-external stow)) {
    fail 'You must install GNU stow to continue...'
  }

  use utils
  utils:do-in-dir ~/dotfiles {
    var target = ~
    stow --verbose --target=$target --delete */
  }
}

# Creates a backup of secrets
fn backup-secrets {
  var name = ~/dotfiles/(hostname)'-'(date +%Y-%m-%d)'-secrets.backup.tgz'
  tar -zcvf $name ~/.ssh ~/.netrc ~/.env*
}

# Backs up brewfile
fn backup-brew {
  brew bundle dump --force --file ~/dotfiles/brew/Brewfile
}

# Install LSPs and tools
fn setup-tools {
  var tools = [
    [sh ~/dotfiles/tprompt/install.sh]

    [go mvdan.cc/gofumpt]
    [go golang.org/x/tools/gopls]
    [go github.com/go-delve/delve/cmd/dlv]
    [go github.com/daveshanley/vacuum]
    [go golang.org/x/tools/cmd/goimports]
    [go github.com/gokcehan/lf]

    [npm dockerfile-language-server-nodejs]
    [npm intelephense]
    [npm typescript-language-server]
    [npm typescript]
    [npm vscode-langservers-extracted]
    [npm bash-language-server]

    [gem solargraph]

    [cargo eza]
    [cargo fd-find]
  ]

  for tool $tools {
    var t = $tool[0]
    var pkg = $tool[1]

    if (not (has-external $t)) {
    	echo (styled 'missing '$t' for '$pkg bold red)
      continue
    }

    echo 'Installing ('$t'):' $pkg

    if (eq $t go) {
      go install $pkg'@latest'
    } elif (eq $t npm) {
      npm i -g $pkg
    } elif (eq $t gem) {
      gem install $pkg
    } elif (eq $t cargo) {
      cargo install $pkg
    } elif (eq $t sh) {
      sh $pkg
    } else {
     	echo (styled 'no install strategy for '$t bold red)
    }
  }
}
