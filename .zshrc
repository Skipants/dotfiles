# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH Options
ZSH_THEME="dracula/dracula"

plugins=(git gitfast history zeus ssh-agent bundler history-substring-search brew)

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
  /opt/homebrew/sbin
  /opt/homebrew/bin
  $HOME/bin
  $HOME/.rd/bin # Rancher desktop
)

# Need to have brew in path before I can use the prefixes
path+=(
  $(brew --prefix imagemagick@6)/bin
  $(brew --prefix libxml2)/bin
  $(brew --prefix libxslt)/bin
)

LDFLAGS+=(
  -L$(brew --prefix imagemagick@6)/lib
  -L$(brew --prefix libffi)/lib
  -L$(brew --prefix libxml2)/lib
  -L$(brew --prefix libxslt)/lib
  -L$(brew --prefix mysql@5.7)/lib
  -L$(brew --prefix zlib)/lib
)

CPPFLAGS+=(
  -I$(brew --prefix imagemagick@6)/include
  -I$(brew --prefix libxml2)/include
  -I$(brew --prefix libxslt)/include
  -I$(brew --prefix mysql@5.7)/include
  -I$(brew --prefix zlib)/include
)

PKG_CONFIG_PATH+=(
  $(brew --prefix imagemagick@6)/lib/pkgconfig
  $(brew --prefix libffi)/lib/pkgconfig
  $(brew --prefix libxml2)/lib/pkgconfig
  $(brew --prefix libxslt)/lib/pkgconfig
  $(brew --prefix mysql@5.7)/lib/pkgconfig
  $(brew --prefix zlib)/lib/pkgconfig
)

# Homebrew autocompletion
if type brew &>/dev/null; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")

  autoload -Uz compinit
  compinit
fi

# Global Aliases
#  This allows these commands to be piped to rather than just used on their own
alias -g be="bundle exec"
alias -g vi=vim

# Aliases
alias aws-mfa='oathtool --totp --base32 --digits=6 $AWS_WONOLO_TOTP_KEY | pbcopy'
alias tf=terraform

# Bindkeys
bindkey -e
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Other environment variables
export BUNDLE_BUILD__GITHUB___MARKDOWN="--with-cflags=-Wno-error=implicit-function-declaration"
export BUNDLE_BUILD__MYSQL2="--with-ldflags=-L$(brew --prefix openssl)/lib --with-cppflags=-I$(brew --prefix openssl)/include"
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
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/aszczepanski/.bun/_bun" ] && source "/Users/aszczepanski/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(/Users/aszczepanski/.local/bin/mise activate zsh)"
