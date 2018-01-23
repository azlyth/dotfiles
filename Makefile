PWD="$(shell pwd)"

link:
	mkdir -p ~/.config/nvim
	ln -sf $(PWD)/.config/nvim/init.vim ~/.config/nvim/init.vim
	ln -sf $(PWD)/.agignore ~/.agignore
	ln -sf $(PWD)/.aliases ~/.aliases
	ln -sf $(PWD)/.bash_profile ~/.bash_profile
	ln -sf $(PWD)/.bash_prompt ~/.bash_prompt
	ln -sf $(PWD)/.functions ~/.functions
	ln -sf $(PWD)/.gitconfig ~/.gitconfig
	ln -sf $(PWD)/.gitignore ~/.gitignore
	ln -sf $(PWD)/.inputrc ~/.inputrc
