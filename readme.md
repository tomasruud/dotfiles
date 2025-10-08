# dotfiles

## Checklist for setting up

1. Install and setup Bitwarden
1. Transfer and unzip secrets
1. Install Homebrew
1. Clone the dotfiles repo `git clone https://github.com/tomasruud/dotfiles.git ~/dotfiles`
1. Install bundle `brew bundle --file "~/dotfiles/brew/Brewfile"`
1. Set default Rust version `rustup default stable`
1. Load dotfiles `make install`
1. Install tools `make tools`
1. (Optional) make Elvish default shell `dot-default-shell`
1. (Optional) install macOS settings `dot-macos-settings`
