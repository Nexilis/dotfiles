if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
fundle plugin jethrokuan/z
fundle init

set -xg VISUAL (type -p nvim)
set -xg EDITOR $VISUAL
set -xg MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -xg FZF_DEFAULT_COMMAND "fd -H -t f -E .cache -E .git -E .mozilla -E .rustup"
set -xg FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -xg FZF_ALT_C_COMMAND "fd -H -t d -E .cache -E .git"
set -xg PATH /snap/bin ~/.bin ~/.local/bin ~/.cargo/bin ~/.luarocks/bin $PATH
set -xg LUA_PATH ~/.luarocks/share/lua/5.4/?.lua ~/.luarocks/share/lua/5.4/?/init.lua /usr/local/share/lua/5.4/?.lua /usr/local/share/lua/5.4/?/init.lua /usr/local/lib/lua/5.4/?.lua /usr/local/lib/lua/5.4/?/init.lua /usr/share/lua/5.4/?.lua /usr/share/lua/5.4/?/init.lua ./?.lua ./?/init.lua
set -xg LUA_CPATH ~/.luarocks/lib/lua/5.4/?.so /usr/local/lib/lua/5.4/?.so /usr/lib/x86_64-linux-gnu/lua/5.4/?.so /usr/lib/lua/5.4/?.so /usr/local/lib/lua/5.4/loadall.so ./?.so

function fish_greeting
    echo It is (set_color yellow)(date +%R)(set_color normal). 🎏 Hello friend, happy 🎣\n
    echo (set_color normal)IP addr of (set_color red)(hostname)(set_color normal)@(set_color blue)(uname -r) (set_color normal)are:
    echo (set_color normal)- pub (set_color green)(curl -s --max-time 1 -connect-timeout 1 ifconfig.me)
    echo (set_color normal)- prv (set_color green)(hostname -I)\n
    echo (set_color red)\>(set_color white)°(set_color yellow)\)\)\)\)(set_color blue)彡
end

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
alias gpsup='git push --set-upstream origin (git_current_branch)'

alias l="exa -lah --git --time-style long-iso --group-directories-first"
alias cat="bat -p --paging=never"
alias cat-img="kitty +kitten icat"
alias o="xdg-open"
alias n="bash -c '(cd ~ && nvim)'"
alias dec="sh ~/pCloudDrive/cyb-decrypt.sh"
alias w="curl http://wttr.in/"
alias nnn="nnn -dHAni"

alias u="flatpak update -y"

starship init fish | source
