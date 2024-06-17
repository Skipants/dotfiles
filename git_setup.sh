#!/bin/bash

set -u

git config --global user.name "Andrew Szczepanski"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global branch.sort -committerdate
git config --global pull.ff only
git config --global push.autoSetupRemote true
git config --global rebase.autosquash true
git config --global rebase.updateRefs true
git config --global rerere.enabled true


# Signing w/ SSH
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_rsa.pub
