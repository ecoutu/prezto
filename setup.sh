#!/usr/bin/env zsh

setopt EXTENDED_GLOB

mv "${ZDOTDIR:-$HOME}/.zshrc" "${ZDOTDIR:-$HOME}/zshrc.bak"

for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  if [[ ! -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]]; then
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  fi
done
