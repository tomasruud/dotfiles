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
  sh ~/dotfiles/tprompt/install.sh

  go install mvdan.cc/gofumpt@latest
  go install golang.org/x/tools/gopls@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/daveshanley/vacuum@latest
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/gokcehan/lf@latest
  go install gotest.tools/gotestsum@latest
  go install github.com/tomasruud/serve@latest

  npm i -g dockerfile-language-server-nodejs
  npm i -g intelephense
  npm i -g typescript-language-server
  npm i -g typescript
  npm i -g vscode-langservers-extracted
  npm i -g bash-language-server

  gem install solargraph

  cargo install eza
  cargo install fd-find
  cargo install bat
  cargo install ripgrep
  cargo install sleek
}
