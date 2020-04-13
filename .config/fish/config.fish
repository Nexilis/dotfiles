if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -x -g EDITOR /usr/local/bin/micro
set -x -g FZF_LEGACY_KEYBINDINGS 0
set -x -g MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x -g PATH ~/.bin ~/.local/bin ~/.cargo/bin /snap/bin $PATH
set -x -g LC_ALL en_GB.UTF-8
set -x -g LANG en_GB.UTF-8

alias sau   "sudo apt update && sudo apt upgrade && sudo apt autoremove"
alias gaa   "git add --all"
alias gap   "git add -p"
alias gco   "git checkout"
alias gcm   "git commit -ev"
alias gst   "git status -sb"
alias gfe   "git fetch"
alias gpl   "git pull"
alias gph   "git push"
alias gbr   "git branch"
alias gmr   "git merge"
alias glg   "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias grs   "git reset --hard"
alias gcl   "git clean -xdf"
alias gpsup "git push --set-upstream origin (git_branch_name)"
alias fd    "fdfind"
alias diff  "diff-so-fancy"
alias ls    "exa"
alias l     "exa -lahF"
alias br    "br -h"
alias cat   "bat -p --paging=never"
