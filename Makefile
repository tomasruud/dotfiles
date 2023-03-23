.PHONY: all

all:
	@echo "hi mom"

backup:
	tar -zcvf backup.tgz ${HOME}/.ssh ${HOME}/.netrc ${HOME}/.env

brewfile:
	brew bundle dump --force --file ./brew/Brewfile