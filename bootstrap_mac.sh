#!/bin/bash

set -u

cd "$(dirname $0)" || exit

# I don't do xcode-select install in this script because it is needed for git, so I can't get this script without it
#  comment is here so I remember that next time
# xcode-select install

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

# brew install asdf # Currently sucks at picking the right bundler version
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
brew install nvm
brew install openssl
brew install postgresql
brew install redis
# brew install rust  ## Currently hangs
brew install shellcheck
brew install sqlite
brew install terraform
brew install vim
brew install zsh

brew install --cask chef-workstation
brew install --cask chromedriver
brew install --cask firefox
brew install --cask iterm2
brew install --cask libreoffice
brew install --cask spotify
brew install --cask spotmenu
brew install --cask virtualbox

if [ ! -d ~/.vimrc ]; then
  cp "$(pwd -P)/.vimrc" ~/.vimrc
fi

if [ ! -d ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm_profiles.json ]; then
  cp "$(pwd -P)/iterm_profiles.json" ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm_profiles.json
fi

# I have to look into my license with this
# if [ ! -d "/Applications/Skitch.app" ]; then
#   mas install 425955336 # Skitch
# fi

if [ ! -d "/Applications/Slack.app" ]; then
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
#  installdmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.2.0/Rancher.Desktop-1.2.0.aarch64.dmg
# fi
if [ ! -d "/Applications/Google Chrome.app" ]; then
  installdmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
fi

# Failed to download
# if [ ! -d "/Applications/zoom.us.app" ]; then
#   sudo installer -pkg https://zoom.us/client/latest/Zoom.pkg -target /
# fi

if [ ! -d ~/.oh-my-zsh ]; then
  rm ~/.zshrc # Prevent oh my zsh from making a copy
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -d ~/.oh-my-zsh/themes/dracula/dracula.zsh-theme ]; then
  git clone git@github.com:dracula/zsh ~/.oh-my-zsh/themes/dracula
fi

cp "$(pwd -P)/.zshrc" ~/

# I don't think I care about this right now
# cp -i "$(pwd -P)/.bash_profile.macos" ~/.bash_profile

. /opt/homebrew/opt/asdf/libexec/asdf.sh

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
