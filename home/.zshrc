# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH Options
ZSH_THEME="dracula/dracula"

plugins=(git gitfast history zeus ssh-agent bundler history-substring-search)

source $ZSH/oh-my-zsh.sh

unsetopt AUTO_CD

# Custom functions
function changed_files(){
  git diff --cached --name-only --diff-filter=ACM | grep "\\.${1:-rb}$"
}

function find_ssm(){
  aws ssm get-parameters-by-path --recursive --path "$1" --profile ${2:-dev}-lead
}

function get_ssm(){
  aws ssm get-parameter --name "$1" --with-decryption --profile ${2:-dev}-lead | jq .Parameter.Value
}

# The prefix before "--". eg current_branch_prefix of "ABC-123--hello" is "ABC-123"
function current_branch_prefix() {
  local branch_name=$(git rev-parse --abbrev-ref HEAD)
  echo "${branch_name%%--*}"
}

function jira() {
  if [[ -n $1 ]]; then
    ticket=$1
  else
    ticket=$(current_branch_prefix)
  fi

  open "https://${JIRA_SUBDOMAIN}.atlassian.net/browse/${ticket}"
}

function mktouch() { mkdir -p $(dirname $1) && touch $1; }

function update_profile() {
  if [ $(pwd -P) = $HOME ]; then
    \curl --output .zshrc https://raw.githubusercontent.com/skipants/dotfiles/master/.zshrc
    source .zshrc
  else
    echo "Run me from the HOME dir, please... it makes things simpler."
  fi
}

# Update paths
path+=(
  /bin
  /usr/local/bin
  /usr/bin
  /usr/sbin
  $HOME/bin
  $HOME/.local/bin
  $HOME/.rd/bin # Rancher desktop
)

# Ubuntu package paths (replacing brew --prefix paths)
if [[ -d /usr/include/ImageMagick-6 ]]; then
  path+=(/usr/bin)
fi

if [[ -d /usr/include/libxml2 ]]; then
  path+=(/usr/bin)
fi

if [[ -d /usr/include/libxslt ]]; then
  path+=(/usr/bin)
fi

LDFLAGS+=(
  -L/usr/lib/x86_64-linux-gnu
  -L/usr/lib
)

CPPFLAGS+=(
  -I/usr/include
  -I/usr/include/ImageMagick-6
  -I/usr/include/libxml2
  -I/usr/include/libxslt
  -I/usr/include/mysql
)

PKG_CONFIG_PATH+=(
  /usr/lib/x86_64-linux-gnu/pkgconfig
  /usr/lib/pkgconfig
  /usr/share/pkgconfig
)

# Ubuntu package completion (replacing Homebrew autocompletion)
autoload -Uz compinit
compinit

# Global Aliases
#  This allows these commands to be piped to rather than just used on their own
alias -g be="bundle exec"
alias -g vi=vim

# Aliases
alias aws-mfa='oathtool --totp --base32 --digits=6 $AWS_WONOLO_TOTP_KEY | xclip -selection clipboard'
alias tf=terraform

# Bindkeys
bindkey -e
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Other environment variables
export BUNDLE_BUILD__GITHUB___MARKDOWN="--with-cflags=-Wno-error=implicit-function-declaration"
export BUNDLE_BUILD__MYSQL2="--with-ldflags=-L/usr/lib/x86_64-linux-gnu --with-cppflags=-I/usr/include/mysql"
export BUNDLE_BUILD__THIN="--with-cflags=-Wno-error=implicit-function-declaration"
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export VISUAL="code --wait --new-window"
export EDITOR=$VISUAL
export PAGER=less

# # Setting up a convention for a secrets file. I would really like to encrypt/decrypt this file at some point.
# #   If you are reading this and have a good idea how let me know. Maybe with gpg?
if [ -s ~/.secrets.env ]; then
  set -o allexport
  . ~/.secrets.env
  set +o allexport
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(~/.local/bin/mise activate zsh)"
