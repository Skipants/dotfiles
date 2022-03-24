# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

unsetopt auto_cd

ZSH_THEME="dracula/dracula"

plugins=(git gitfast history zeus ssh-agent bundler history-substring-search brew)

source $ZSH/oh-my-zsh.sh

export PATH="$(brew --prefix)/sbin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"

# Homebrew autocompletion
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"

  autoload -Uz compinit
  compinit
fi

export VISUAL="code --wait --new-window"
export EDITOR=$VISUAL
export PATH=/usr/local/bin:$HOME/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

bindkey -e
bindkey '^r' history-incremental-search-backward

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

function update_profile() {
  if [ $(pwd -P) = $HOME ]; then
    \curl --output .zshrc https://raw.githubusercontent.com/skipants/dotfiles/master/.zshrc
    source .zshrc
  else
    echo "Run me from the HOME dir, please... it makes things simpler."
  fi
}

function jira() {
  if [[ -n $1 ]]; then
    ticket=$1
  else
    IFS='-'; local temp=($(git rev-parse --abbrev-ref HEAD))
    ticket="${temp[1]}-${temp[2]}"
  fi

  open "https://financeit.atlassian.net/browse/${ticket}"
}

# Replace BSD utils with GNU ones
export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
export MANPATH="$(brew --prefix)/opt/grep/libexec/gnuman:$MANPATH"

# Find Homebrew libxml and libxlst
export PATH="$PATH:$(brew --prefix)/opt/libxml2/bin:$(brew --prefix)/opt/libxslt/bin"
export LDFLAGS="$LDFLAGS -L$(brew --prefix)/opt/libxml2/lib -L$(brew --prefix)/opt/libxslt/lib -L$(brew --prefix)/opt/libffi/lib"
export CPPFLAGS="$CPPFLAGS -I$(brew --prefix)/opt/libxml2/include -I$(brew --prefix)/opt/libxslt/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(brew --prefix)/opt/libxml2/lib/pkgconfig:$(brew --prefix)/opt/libxslt/lib/pkgconfig:$(brew --prefix)/opt/libffi/lib/pkgconfig"
export ARCHFLAGS='-arch x86_64'
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Find Homebrew imagemagick
export PATH="$(brew --prefix)/opt/imagemagick@6/bin:$PATH"
export LDFLAGS="$LDFLAGS -L$(brew --prefix)/opt/imagemagick@6/lib"
export CPPFLAGS="$CPPFLAGS -I$(brew --prefix)/opt/imagemagick@6/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(brew --prefix)/opt/imagemagick@6/lib/pkgconfig"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
PATH=/usr/local/bin:$PATH

. "$(brew --prefix)/opt/asdf/libexec/asdf.sh"

export PATH="$(brew --prefix imagemagick@6)/bin:$PATH"
export BUNDLE_BUILD__GITHUB___MARKDOWN="--with-cflags=-Wno-error=implicit-function-declaration"
export BUNDLE_BUILD__MYSQL2="--with-ldflags=-L$(brew --prefix)/opt/openssl/lib --with-cppflags=-I$(brew --prefix)/opt/openssl/include"
export BUNDLE_BUILD__THIN="--with-cflags=-Wno-error=implicit-function-declaration"

alias -g be="bundle exec"
alias -g vi=vim

alias tf=terraform

# I'll put these in a config file later
git config --global user.name "Andrew Szczepanski"
git config --global user.email aszczepanski@financeit.io # Just going to use my work email for now
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.st status

source <(kubectl completion zsh)
