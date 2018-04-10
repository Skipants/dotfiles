#!/usr/bin/bash

PATH="$PATH:$HOME/bin"

YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
RED="\[\033[0;31m\]"
RESET="\[\033[0m\]"

GOROOT=/usr/local/go
GOPATH="$HOME/go"
PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

function parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function path() {
  path=${PWD/#$HOME/'~'}
  if [[ ${#path} -ge 30 ]];then
    path=${path: -27}
    path=".../${path#*\/}"
  fi

  echo $path
}

# PS_INFO="$GREEN\u$RESET$BLUE\w"
PS_PATH="$BLUE\$(path)"
PS_GIT="$GREEN\$(parse_git_branch)"
PS_TIME="$RED[\t]"
export PS1="${PS_TIME} ${PS_PATH} ${PS_GIT}${RESET}> "

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export CPPFLAGS="-I/usr/local/opt/readline/include -I/usr/local/opt/qt@5.5/include"
export EDITOR="subl -w"
export HISTCONTROL=ignorespace
export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/qt@5.5/lib"
export PKG_CONFIG_PATH="/usr/local/opt/qt@5.5/lib/pkgconfig"

alias be="bundle exec"

eval "$(rbenv init -)"

if [[ $(type -P brew) ]]; then
  export PATH="$(brew --prefix qt@5.5)/bin:$PATH"

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# Attempts to fix an issue with Xvfb not working correctly when using the headless gem
#   https://github.com/leonid-shevtsov/headless#tmpx11-unix-is-missing
if [ -f $(type -P xvfb) ] && [ ! -d "/tmp/.X11-unix" ]; then
  mkdir /tmp/.X11-unix
  sudo chmod 1777 /tmp/.X11-unix
  sudo chown root /tmp/.X11-unix/
fi
