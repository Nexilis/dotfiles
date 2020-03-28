#!/usr/bin/env bash

rm -r -f ~/.oh-my-zsh
ln -s /usr/share/oh-my-zsh ~/.oh-my-zsh
cp -f -r -s ~/dotfiles/home/. ~/
cp -f -r -s ~/dotfiles/.config ~/
chsh -s /bin/zsh

pacman -S yay
pacman -S vim
pacman -S ripgrep
# terminal tools: tilix, broot, micro, diff-so-fancy, exa, bat, fzf, fd-find
pacman -S mc
pacman -S neofetch
pacman -S spotify
pacman -S telegram-desktop
pacman -S dotnet-sdk
# add fsharp
# add java?
pacman -S clojure
pacman -S aspell-en libmythes mythes-en languagetool # improved spellchecking

#pacman -S steam-manjaro
#pacman -S lib32-libxrandr    # GOG - Hyper Light Drifter on Manjaro
#pacman -S lib32-openal       # GOG - Hyper Light Drifter on Manjaro
#pacman -S wmctrl            # xfce icon fix hack

yay -S oh-my-zsh-git
yay -S google-chrome
# add brave
yay -S dropbox
yay -S jetbrains-toolbox
yay -S leiningen
yay -S leiningen-completions
# add rust
# add sublime
# add vscodium
# add bitwarden
# add tilix
# add joplin

# revise fonts
yay -S ttf-ms-fonts
yay -S ttf-dejavu-sans-mono-powerline-git
yay -S otf-fira-code-git

#yay -S slack-desktop
#yay -S xseticon             # xfce icon fix hack
#yay -S ttf-unifont           # font fix for Spacemacs
