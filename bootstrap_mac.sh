#!/bin/bash

set -u

cd "$(dirname $0)" || exit

# You'll still want to run `xcode-select install` first

ln -fs "$(pwd -P)/.vimrc" ~/.vimrc
ln -fs "$(pwd -P)/iterm_profiles.json" ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm_profiles.json

if [ -x "$(command -v brew)" ]; then
  brew update
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install readline && brew link readline
brew install zlib

export CPPFLAGS="-I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include"
export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib"

homebrew_packages=(
  asdf
  awscli
  coreutils
  freetype
  gnupg
  git
  gnutls
  go
  htop
  jpeg
  openssl
  postgresql
  redis
  rust
  shellcheck
  sqlite
  terraform
  zsh
)

for pkg in "${homebrew_packages[@]}"
do
  brew install "${pkg}"
done

brew upgrade

if [[ ! -f ~/.vim/colors/monokai.vim ]]; then
  mkdir -p ~/.vim/colors/
  (cd ~/.vim/colors/ && curl -O https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim)
fi


if [ ! -d ~/.oh-my-zsh ]; then
  rm ~/.zshrc # Prevent oh my zsh from making a copy
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  ln -fs "$(pwd -P)/.zshrc" ~/.zshrc
fi
