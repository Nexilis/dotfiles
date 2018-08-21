#!/usr/bin/env bash

rm ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
rm ~/.profile
ln -s ~/dotfiles/.profile ~/.profile
rm ~/.gitconfig
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
rm -r ~/.oh-my-zsh
ln -s /usr/share/oh-my-zsh ~/.oh-my-zsh

FILES=$(ls -a)
IGNORED=". .. LICENSE README.md"

is_ignored() {
    local return_value="false"
    for i in $IGNORED; do
        if [ $1 = $i ]; then
            local return_value="true"
        fi
    done
    echo "$return_value"
}

for f in $FILES; do
    result=$(is_ignored $f)
    if [ $result != "true" ]; then
        echo "$f"
        # mv ~/$f ~/dotfiles_old
        # rm $f
        # ln -s $f ~/$f
    fi
done
