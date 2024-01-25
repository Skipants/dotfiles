#!/bin/bash

set -u

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
brew install docker docker-compose
brew install freetype
brew install gh
brew install git
brew install gnu-time
brew install gnupg
brew install gnutls
brew install go
brew install htop
brew install jpeg
brew install mas
brew install nvm
brew install openssl
brew install postgresql
brew install redis
brew install shellcheck
brew install sqlite
brew install terraform
brew install vim
brew install zsh

$(pwd -P)/git_setup.sh

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
. "$HOME/.asdf/asdf.sh"
asdf update

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

brew install --cask chromedriver
brew install --cask firefox
brew install --cask libreoffice
brew install --cask spotify
brew install --cask spotmenu


# I have to look into my license with this
# if [ ! -d "/Applications/Skitch.app" ]; then
#   mas install 425955336 # Skitch
# fi

if [ ! -e "/Applications/Slack.app" ]; then
  mas install 803453959 # Slack
fi

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

# This failed installing -- the download worked fine though
# if [ ! -d "/Applications/Rancher Desktop.app" ]; then
#  installdmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.12.2/Rancher.Desktop-1.12.2.aarch64.dmg
# fi

if [ ! -e "/Applications/Google Chrome.app" ]; then
  installdmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
fi

if [ ! -e ~/.oh-my-zsh ]; then
  rm ~/.zshrc # Prevent oh my zsh from making a copy
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -e ~/.oh-my-zsh/themes/dracula/dracula.zsh-theme ]; then
  git clone https://github.com/dracula/zsh.git ~/.oh-my-zsh/themes/dracula
fi

if [ ! -e ~/.pryrc ]; then
  cp "$(pwd -P)/.pryrc" ~/
fi

if [ ! -e ~/.vimrc ]; then
  cp "$(pwd -P)/.vimrc" ~/
fi

if [ ! -e ~/.zshrc ]; then
  cp "$(pwd -P)/.zshrc" ~/
fi

# I don't think I care about this right now
# cp -i "$(pwd -P)/.bash_profile.macos" ~/.bash_profile

# Needed sudo permissions here or chmod /usr/local/opt... not sure what i want to do
asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest
gem install bundler

if [[ ! -f ~/.vim/colors/monokai.vim ]]; then
  mkdir -p ~/.vim/colors/
  (cd ~/.vim/colors/ && curl -O https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim)
fi

echo "Just install VSCode separately I'm tired of automating this!!!"
echo "You're using settings syncing so that should update automatically if you allow it to."
