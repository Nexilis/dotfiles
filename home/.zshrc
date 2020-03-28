export ZSH=$HOME/.oh-my-zsh

export VISUAL=/usr/local/bin/micro
export EDITOR="$VISUAL"

ZSH_THEME="robbyrussell"

plugins=(
  z
)

source $ZSH/oh-my-zsh.sh
source ~/.config/broot/launcher/bash/br

alias sau="sudo apt update && sudo apt upgrade && sudo apt autoremove"
alias gaa='git add --all'
alias gap='git add -p'
alias gco='git checkout'
alias gcm='git commit -ev'
alias gst='git status -sb'
alias gfe='git fetch'
alias gpl='git pull'
alias gph='git push'
alias gbr='git branch'
alias gmr='git merge'
alias glg="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias grs='git reset --hard'
alias gcl='git clean -xdf'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias fd=fdfind
alias diff="diff-so-fancy"
alias ls="exa"
alias l="exa -lahF"
alias br="br -h"
alias cat="bat -p"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#export PATH="$(yarn global bin):$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

neofetch
