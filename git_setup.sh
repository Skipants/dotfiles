#!/bin/bash

set -u

git config --global user.name "Andrew Szczepanski"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.ff only
git config --global push.autoSetupRemote true
