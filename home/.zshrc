export VISUAL=/usr/local/bin/micro
export EDITOR="$VISUAL"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="/snap/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

source ~/.config/broot/launcher/bash/br
source ~/.zsh/antigen.zsh

antigen use oh-my-zsh
antigen bundle rupa/z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen theme sindresorhus/pure
antigen apply

alias sau="sudo apt update && sudo apt upgrade && sudo apt autoremove"
alias gaa="git add --all"
alias gap="git add -p"
alias gco="git checkout"
alias gcm="git commit -ev"
alias gst="git status -sb"
alias gfe="git fetch"
alias gpl="git pull"
alias gph="git push"
alias gbr="git branch"
alias gmr="git merge"
alias glg="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias grs="git reset --hard"
alias gcl="git clean -xdf"
alias gpsup="git push --set-upstream origin $(git_current_branch)"
alias fd="fdfind"
alias diff="diff-so-fancy"
alias ls="exa"
alias l="exa -lahF"
alias br="br -h"
alias cat="bat -p --paging=never"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

neofetch
