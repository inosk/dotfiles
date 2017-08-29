#!/bin/bash

cd $(dirname $0)

cp .gitconfig.tmpl .gitconfig

for dotfile in .?*
do
  # exclude parent dir and .git
  if [ $dotfile != ".." ] && [ $dotfile != ".git" ] && [ $dotfile != ".gitmodule" ] && [ $dotfile != ".gitconfig" ] && [ $dotfile != ".gitconfig.tmpl" ] && [ $dotfile != ".gitmodules" ] && [ $dotfile != ".gitignore" ]
  then
    ln -Fis "$PWD/$dotfile" $HOME
  fi
done

# for nvim
mkdir -p ~/.config
ln -Fis "$PWD/.vim" ~/.config/nvim

# for git
git config --global core.excludesfile ~/.gitignore_global

# submodule
git submodule init
git submodule update

# anyenv
git clone https://github.com/riywo/anyenv ~/.anyenv
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
git clone https://github.com/yyuu/pyenv-virtualenv ~/.anyenv/envs/pyenv/plugins/pyenv-virtualenv
