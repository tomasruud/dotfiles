.PHONY: tools
tools:
	CGO_ENABLED=0 go install -ldflags="-s -w" ./tprompt/main.go

	go install mvdan.cc/gofumpt@latest
	go install golang.org/x/tools/gopls@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install github.com/daveshanley/vacuum@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/gokcehan/lf@latest
	go install gotest.tools/gotestsum@latest
	go install github.com/tomasruud/dog@latest
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

.PHONY: install
install:
	stow --verbose --target=$${HOME} --restow */

.PHONY: uninstall
uninstall:
	stow --verbose --target=$${HOME} --delete */

.PHONY: backup-secrets
backup-secrets:
	tar -zcvf $(shell hostname)-$(shell date +%Y-%m-%d)-secrets.backup.tgz ~/.ssh ~/.netrc ~/.env*

.PHONY: backup-brew
backup-brew:
	brew bundle dump --force --file ./brew/Brewfile
