set -xg VISUAL (type -p nvim)
set -xg EDITOR $VISUAL
set -xg MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -xg FZF_DEFAULT_COMMAND "fd -H --type f -E .cache -E flatpak -E .rustup -E .steam -E .mozilla"
set -xg FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -xg FZF_ALT_C_COMMAND "fd -H -t d -E .cache -E .git -E flatpak -E .steam -E .mozilla"
set -xg PATH /snap/bin ~/.bin ~/.local/bin ~/.cargo/bin ~/.luarocks/bin $PATH

set -l LUA_VER 5.4
set -xg LUA_PATH $HOME/.luarocks/share/lua/$LUA_VER/\?.lua\;$HOME/.luarocks/share/lua/$LUA_VER/\?/init.lua\;/usr/local/share/lua/$LUA_VER/\?.lua\;/usr/local/share/lua/$LUA_VER/\?/init.lua\;/usr/local/lib/lua/$LUA_VER/\?.lua\;/usr/local/lib/lua/$LUA_VER/\?/init.lua\;/usr/share/lua/$LUA_VER/\?.lua\;/usr/share/lua/$LUA_VER/\?/init.lua\;./\?.lua\;./\?/init.lua\;$LUA_PATH
set -xg LUA_CPATH $HOME/.luarocks/lib/lua/$LUA_VER/\?.so\;$HOME/.luarocks/lib64/lua/$LUA_VER/\?.so\;/usr/local/lib/lua/$LUA_VER/\?.so\;/usr/local/lib64/lua/$LUA_VER/\?.so\;/usr/lib/x86_64-linux-gnu/lua/$LUA_VER/\?.so\;/usr/lib/lua/$LUA_VER/\?.so\;/usr/lib64/lua/$LUA_VER/\?.so\;/usr/local/lib/lua/$LUA_VER/loadall.so\;/usr/local/lib64/lua/$LUA_VER/loadall.so\;./\?.so\;$LUA_CPATH

function fish_greeting
    echo It is (set_color yellow)(date +%R)(set_color normal). 🎏 Hello friend, happy 🎣\n
    echo (set_color normal)IP addr of (set_color red)(hostname)(set_color normal)@(set_color blue)(uname -r) (set_color normal)are:
    echo (set_color normal)- pub (set_color green)(curl -s --max-time 1 --connect-timeout 1 ifconfig.me)
    echo (set_color normal)- prv (set_color green)(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')\n
    echo (set_color red)\>(set_color white)°(set_color yellow)\)\)\)\)(set_color blue)彡
end

function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
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

if type -q lazygit
  abbr --add -g lg 'lazygit'
  # macOS lazygit defaults to ~/Library/Application Support; point it at the
  # repo-symlinked config under ~/.config so it follows the dotfiles migration.
  set -xg LG_CONFIG_FILE $HOME/.config/lazygit/config.yml
end

# `ls` → `eza` abbreviation
# Requires `brew install eza`
if type -q eza
  abbr --add -g l 'eza -lah --git --time-style long-iso --group-directories-first'
end

# `cat` → `bat` abbreviation
# Requires `brew install bat`
if type -q bat
  abbr --add -g cat 'bat -p --paging=never'
end

alias dec="gocryptfs '$HOME/Documents/sync/work-sync/.cipher' $HOME/Documents/work-synced-secrets"
alias unmount="umount -f $HOME/Documents/work-synced-secrets"

alias u="brew update && brew upgrade && brew upgrade --cask && brew cleanup"

alias python="python3"
alias lua="lua5.4"

zoxide init fish | source

starship init fish | source

