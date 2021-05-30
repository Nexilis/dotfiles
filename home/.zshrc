export VISUAL=nvim
export EDITOR="$VISUAL"
export TERM=xterm-256color # needed for tmux to work with 256 colors
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_COMMAND="fdfind -H -t f --no-ignore-vcs"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fdfind -H -t d"
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
# antigen theme steeef
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
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias diff="diff-so-fancy"
alias l="exa -lah --git --time-style long-iso --group-directories-first"
alias bra="br -ghp"
alias brh="br -ghp"
alias brs="br -hs"
alias cat="bat -p --paging=never"
alias o="xdg-open"
alias fd="fdfind"
alias lg="lazygit"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
