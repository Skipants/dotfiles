#!/usr/local/bin/zsh

set -o magicequalsubst

export ZSH=~/.oh-my-zsh

ZSH_THEME="muse"

plugins=(
  git
  bundler
  osx
  pyenv
  rake
  rbenv
  ruby
)

source $ZSH/oh-my-zsh.sh


export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export CPPFLAGS="-I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include"
export HISTCONTROL=ignorespace
export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib"
export PATH="$HOME/go/bin:/usr/local/go/bin:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:$HOME/.cargo/bin:$PATH"

alias tf="terraform"
