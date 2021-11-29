export VISUAL=nvim
export EDITOR="$VISUAL"
export TERM=xterm-256color # needed for tmux to work with 256 colors
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_COMMAND="fd -H -t f -E .cache -E .git -E .mozilla -E .rustup"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -H -t d -E .cache -E .git"
export PATH="/snap/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.luarocks/bin:$PATH"
export LUA_PATH="$HOME/.luarocks/share/lua/5.4/?.lua;$HOME/.luarocks/share/lua/5.4/?/init.lua;/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua;/usr/local/lib/lua/5.4/?.lua;/usr/local/lib/lua/5.4/?/init.lua;/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;./?.lua;./?/init.lua"
export LUA_CPATH="$HOME/.luarocks/lib/lua/5.4/?.so;/usr/local/lib/lua/5.4/?.so;/usr/lib/x86_64-linux-gnu/lua/5.4/?.so;/usr/lib/lua/5.4/?.so;/usr/local/lib/lua/5.4/loadall.so;./?.so"

source ~/.zsh/antigen.zsh

antigen use oh-my-zsh
antigen bundle rupa/z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen apply

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

alias l="exa -lah --git --time-style long-iso --group-directories-first"
alias cat="bat -p --paging=never"
alias cat-img="kitty +kitten icat"
alias o="xdg-open"
alias n="(cd ~ && nvim)"
alias dec="sh ~/pCloudDrive/cyb-decrypt.sh"
alias w="curl http://wttr.in/"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
