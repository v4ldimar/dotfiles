#! /bin/bash
# copy dotfiles to home directory

DOTFILES=(.gitconfig .gitignore .zshrc)
for dotfile in $(echo ${DOTFILES[*]});
do
    cp ~/dotfiles/$(echo $dotfile) ~/$(echo $dotfile)
done
