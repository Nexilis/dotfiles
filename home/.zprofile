# Login environment, POSIX sh. The login shell is zsh, so everything started
# through it gets this: Neovide's nvim (via /usr/bin/login), ssh sessions, and
# nushell, whose config.nu imports it (see AGENTS.md "Shell: nushell").

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

for dir in /snap/bin "$HOME/go/bin" "$HOME/.luarocks/bin" "$HOME/.cargo/bin" \
  "$HOME/.local/bin" "$HOME/.bin"; do
  case ":$PATH:" in
    *":$dir:"*) ;;
    *) [ -d "$dir" ] && PATH="$dir:$PATH" ;;
  esac
done
export PATH

export VISUAL=nvim
export EDITOR="$VISUAL"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_COMMAND="fd -H --type f -E .cache -E flatpak -E .rustup -E .steam -E .mozilla"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -H -t d -E .cache -E .git -E flatpak -E .steam -E .mozilla"
# macOS lazygit defaults to ~/Library/Application Support; point it at the
# repo-symlinked config under ~/.config.
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# Set once: a nested login shell would otherwise append the same entries again.
lua_ver=5.4
rocks="$HOME/.luarocks"
[ -n "${LUA_PATH:-}" ] || export LUA_PATH="$rocks/share/lua/$lua_ver/?.lua;$rocks/share/lua/$lua_ver/?/init.lua;/usr/local/share/lua/$lua_ver/?.lua;/usr/local/share/lua/$lua_ver/?/init.lua;/usr/local/lib/lua/$lua_ver/?.lua;/usr/local/lib/lua/$lua_ver/?/init.lua;/usr/share/lua/$lua_ver/?.lua;/usr/share/lua/$lua_ver/?/init.lua;./?.lua;./?/init.lua;"
[ -n "${LUA_CPATH:-}" ] || export LUA_CPATH="$rocks/lib/lua/$lua_ver/?.so;$rocks/lib64/lua/$lua_ver/?.so;/usr/local/lib/lua/$lua_ver/?.so;/usr/local/lib64/lua/$lua_ver/?.so;/usr/lib/x86_64-linux-gnu/lua/$lua_ver/?.so;/usr/lib/lua/$lua_ver/?.so;/usr/lib64/lua/$lua_ver/?.so;/usr/local/lib/lua/$lua_ver/loadall.so;/usr/local/lib64/lua/$lua_ver/loadall.so;./?.so;"
unset lua_ver rocks dir
