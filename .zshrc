# Homebrew autocompletion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

unsetopt auto_cd

ZSH_THEME="dracula"

plugins=(git gitfast history zeus ssh-agent bundler history-substring-search brew)

source $ZSH/oh-my-zsh.sh

export VISUAL="code --wait --new-window"
export EDITOR=$VISUAL
export PATH=/usr/local/bin:$HOME/bin:$PATH
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

bindkey -e
bindkey '^r' history-incremental-search-backward

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

alias -g vi=vim

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
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"

# Find Homebrew libxml and libxlst
export PATH="$PATH:/usr/local/opt/libxml2/bin:/usr/local/opt/libxslt/bin"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/libxml2/lib -L/usr/local/opt/libxslt/lib -L/usr/local/opt/libffi/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/libxml2/include -I/usr/local/opt/libxslt/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/libxml2/lib/pkgconfig:/usr/local/opt/libxslt/lib/pkgconfig:/usr/local/opt/libffi/lib/pkgconfig"
export ARCHFLAGS='-arch x86_64'
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Find Homebrew imagemagick
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/imagemagick@6/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/imagemagick@6/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/imagemagick@6/lib/pkgconfig"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
PATH=/usr/local/bin:$PATH

. $HOME/.asdf/asdf.sh
. /Users/aszczepanski/.asdf/asdf.sh
export PATH="$(brew --prefix imagemagick@6)/bin:$PATH"
export BUNDLE_BUILD__GITHUB___MARKDOWN="--with-cflags=-Wno-error=implicit-function-declaration"
export BUNDLE_BUILD__MYSQL2="--with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include"
export BUNDLE_BUILD__THIN="--with-cflags=-Wno-error=implicit-function-declaration"

alias be="bundle exec"
alias code="code -w --new-window"
alias tf=terraform

git config alias.br=branch
git config alias.co=checkout
git config alias.st=status

source <(kubectl completion zsh)
