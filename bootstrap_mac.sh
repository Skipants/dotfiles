#!/bin/bash

set -u

cd "$(dirname $0)" || exit

xcode-select install

if [ -x "$(command -v brew)" ]; then
  brew update
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install readline && brew link readline
brew install zlib

export CPPFLAGS="-I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include"
export LDFLAGS="-L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib"

brew upgrade

brew install asdf
brew install awscli
brew install coreutils
brew install freetype
brew install git
brew install gnupg
brew install gnutls
brew install go
brew install htop
brew install jpeg
brew install mas
brew install openssl
brew install postgresql
brew install redis
brew install rust
brew install shellcheck
brew install sqlite
brew install terraform
brew install vim
brew install zsh

brew install --cask chef-workstation
brew install --cask chromedriver
brew install --cask firefox
brew install --cask iterm2
brew install --cask java
brew install --cask libreoffice
brew install --cask spectacle
brew install --cask spotify
brew install --cask spotmenu
brew install --cask vagrant
brew install --cask virtualbox

if [ ! -d ~/.vimrc ]; then
  cp "$(pwd -P)/.vimrc" ~/.vimrc
fi

if [ ! -d ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm_profiles.json ]; then
  cp "$(pwd -P)/iterm_profiles.json" ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm_profiles.json
fi

mas install 425955336 # Skitch
mas install 803453959 # Slack

function installdmg {
    set -x
    tempd=$(mktemp -d)
    curl $1 > $tempd/pkg.dmg
    listing=$(sudo hdiutil attach $tempd/pkg.dmg | grep Volumes)
    volume=$(echo "$listing" | cut -f 3)
    if [ -e "$volume"/*.app ]; then
      sudo cp -rf "$volume"/*.app /Applications
    elif [ -e "$volume"/*.pkg ]; then
      package=$(ls -1 "$volume" | grep .pkg | head -1)
      sudo installer -pkg "$volume"/"$package" -target /
    fi
    sudo hdiutil detach "$(echo "$listing" | cut -f 1)"
    rm -rf $tempd
    set +x
}

if [ ! -d "/Applications/Rancher Desktop" ]; then
  installdmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.2.0/Rancher.Desktop-1.2.0.aarch64.dmg
fi

if [ ! -d "/Applications/Google Chrome" ]; then
  installdmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
fi

if [ ! -d "/Applications/zoom.us" ]; then
  sudo installer -pkg https://zoom.us/client/latest/Zoom.pkg -target /
fi

if [ ! -d ~/.oh-my-zsh ]; then
  rm ~/.zshrc # Prevent oh my zsh from making a copy
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  cp "$(pwd -P)/.zshrc" ~/
fi

cp -i "$(pwd -P)/.bashrc" ~/.bashrc
cp -i "$(pwd -P)/.bash_profile" ~/.bash_profile

asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest
gem install bundler

if [[ ! -f ~/.vim/colors/monokai.vim ]]; then
  mkdir -p ~/.vim/colors/
  (cd ~/.vim/colors/ && curl -O https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim)
fi

if [ ! -d ~/.oh-my-zsh ]; then
  rm ~/.zshrc # Prevent oh my zsh from making a copy
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  ln -fs "$(pwd -P)/.zshrc" ~/.zshrc
fi

echo "Just install VSCode separately I'm tired of automating this!!!"
echo "You're using settings syncing so that should update automatically if you allow it to."
