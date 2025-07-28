#!/bin/bash

set -eu

cd "$(dirname $0)" || exit

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    gnupg \
    htop \
    libffi-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libreadline-dev \
    libssl-dev \
    libyaml-dev \
    oathtool \
    postgresql \
    redis-server \
    shellcheck \
    software-properties-common \
    sqlite3 \
    stow \
    vim \
    wget \
    xclip \
    zlib1g-dev \
    zsh

if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
fi

sudo apt install terraform

if [ ! -f /usr/share/keyrings/githubcli-archive-keyring.gpg ]; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
fi

sudo apt install gh

if [ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
fi

sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

if ! groups $USER | grep -q docker; then
    sudo usermod -aG docker $USER
fi

if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

if [ ! -f /etc/apt/trusted.gpg.d/packages.microsoft.gpg ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    rm packages.microsoft.gpg
fi

sudo apt install code

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
fi

sudo apt install -y golang-go

bash "$(pwd -P)/git_setup.sh"

if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
fi

if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

sudo snap install firefox
sudo snap install libreoffice
sudo snap install spotify

if ! command -v google-chrome &> /dev/null; then
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
        sudo apt update
    fi
    sudo apt install google-chrome-stable
fi

if ! command -v slack &> /dev/null; then
    sudo snap install slack --classic
fi

if [ ! -e ~/.oh-my-zsh ]; then
  [ -f ~/.zshrc ] && rm ~/.zshrc
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -e ~/.oh-my-zsh/themes/dracula/dracula.zsh-theme ]; then
  git clone https://github.com/dracula/zsh.git ~/.oh-my-zsh/themes/dracula
fi

if ! command -v ruby &> /dev/null; then
    mise use -g ruby@latest
    mise exec -- gem install bundler
fi

if [ ! -f ~/.vim/colors/monokai.vim ]; then
  mkdir -p ~/.vim/colors/
  (cd ~/.vim/colors/ && curl -O https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim)
fi

if [ ! -f /usr/share/keyrings/wezterm-fury.gpg ]; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    sudo apt update
fi

sudo apt install wezterm

stow home
