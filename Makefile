.PHONY: install

install:
	stow --verbose --target=${HOME} --restow */

uninstall:
	stow --verbose --target=${HOME} --delete */

secrets:
	tar -zcvf backup.tgz ${HOME}/.ssh ${HOME}/.netrc ${HOME}/.env

brew-dump:
	brew bundle dump --force --file ./brew/Brewfile

brew-install:
	brew bundle --file ${HOME}/Brewfile