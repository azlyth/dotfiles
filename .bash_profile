# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases, and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{extra,bash_prompt,apikeys,exports,aliases,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTCONTROL=ignorespace
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh mosh sshfs

# Bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export PATH=/usr/local/bin:$PATH

# No more pyc files!
export PYTHONDONTWRITEBYTECODE=1

# Use brew's python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc' ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc';
fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc' ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc';
fi

export GOPATH="$HOME/src/go"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Set the colors for `ls`
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Setup direnv
eval "$(direnv hook bash)"

# Set default editor
export EDITOR="nvim"

# Add brew's sbin to PATH
export PATH="/usr/local/sbin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Homebrew's OpenSSL
export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# nvm
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
#[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"

# yvm
#export YVM_DIR=/usr/local/opt/yvm
#[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh

# ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export BASH_SILENCE_DEPRECATION_WARNING=1

# Setup broot
#source /Users/peter/Library/Preferences/org.dystroy.broot/launcher/bash/br

# asdf version manager
#source $(brew --prefix asdf)/asdf.sh
#source $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

# To get around an issue with the Docker credential helper
export CLOUDSDK_PYTHON=python2

# Linkerd path
export PATH=$PATH:/Users/peter/.linkerd2/bin

source /Users/peter/Library/Application\ Support/org.dystroy.broot/launcher/bash/br

# Use new gcloud auth plugin
# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
