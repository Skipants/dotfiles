#!/bin/bash

set -ux

cd "$(dirname $0)" || exit

if [ -x "$(command -v brew)" ]; then
  brew update
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

brew install readline && brew link readline
brew install zlib

export CPPFLAGS="-I$(brew --prefix)/opt/readline/include -I$(brew --prefix)/opt/zlib/include"
export LDFLAGS="-L$(brew --prefix)/opt/readline/lib -L$(brew --prefix)/opt/zlib/lib"

brew upgrade

brew install awscli
brew install cmake
brew install coreutils
brew install docker docker-compose docker-credential-helper
brew install freetype
brew install gh
brew install git
brew install gnu-time
brew install gnupg
brew install gnutls
brew install go
brew install htop
brew install jpeg
brew install mise
brew install nvm
brew install openssl
brew install postgresql
brew install redis
brew install shellcheck
brew install sqlite
brew install stow
brew install terraform
brew install vim
brew install zlib
brew install zsh

$(pwd -P)/git_setup.sh

brew install --cask chromedriver
brew install --cask firefox
brew install --cask google-chrome
brew install --cask libreoffice
brew install --cask obsidian
brew install --cask rectangle
brew install --cask slack
brew install --cask spotify
brew install --cask spotmenu
brew install --cask visual-studio-code
brew install --cask wezterm

if [ ! -e ~/.oh-my-zsh ]; then
  rm ~/.zshrc # Prevent oh my zsh from making a copy
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -e ~/.oh-my-zsh/themes/dracula/dracula.zsh-theme ]; then
  git clone https://github.com/dracula/zsh.git ~/.oh-my-zsh/themes/dracula
fi

mise use -g ruby@latest
gem install bundler

if [[ ! -f ~/.vim/colors/monokai.vim ]]; then
  mkdir -p ~/.vim/colors/
  (cd ~/.vim/colors/ && curl -O https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim)
fi

cp -r macos_home/bin/* /usr/local/bin/

stow macos_home