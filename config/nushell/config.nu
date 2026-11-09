# Nushell config. Ghostty starts nu directly (see AGENTS.md "Shell: nushell").

$env.config.show_banner = false
# SQLite history records the directory and exit status of each command.
$env.config.history.file_format = "sqlite"

# The environment lives in ~/.zprofile (home/.zprofile), so programs started
# through the zsh login shell, such as Neovide's nvim, get the same one. nu
# imports it here; a Dock-launched Ghostty starts nu with launchd's minimal env.
if (which zsh | is-not-empty) {
    ^zsh -lc 'env -0'
    | split row (char nul)
    | parse --regex '(?s)^(?<name>[^=]+)=(?<value>.*)$'
    | where name not-in [PWD OLDPWD SHLVL _]
    | reduce --fold {} {|it, acc| $acc | insert $it.name $it.value }
    | load-env
    $env.PATH = ($env.PATH | split row (char esep) | uniq)
}

alias gst = git status -sb
alias gpl = git pull
alias lg = lazygit
alias cat = bat -p --paging=never
alias cld = claude --chrome
alias python = python3
alias dec = gocryptfs ~/Documents/sync/work-sync/.cipher ~/Documents/work-synced-secrets
alias unmount = umount -f ~/Documents/work-synced-secrets

# `ls -la ...[]` lists nothing, so the no-argument case calls ls without a spread.
def l [...paths: glob] {
    let entries = if ($paths | is-empty) { ls -la } else { ls -la ...$paths }
    $entries | sort-by type name | select name type size modified mode
}

# yazi shell wrapper from yazi-rs.github.io/docs/quick-start: cd to where yazi quit.
def --env yy [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != $env.PWD and ($cwd | path exists) {
        cd $cwd
    }
    rm -fp $tmp
}

const init_tools = [
    [name args];
    [carapace [_carapace nushell]]
    [fzf [--nushell]]
    [starship [init nu]]
    [zoxide [init nushell]]
]

def init-file [name: string] {
    $nu.user-autoload-dirs | first | path join $"($name).nu"
}

# nu cannot `source` a pipe, so each tool's init is saved where nu autoloads it.
# Autoload runs after config.nu, so a file written here loads in this session.
# A failed run saves nothing, so the next start retries it; an init file for an
# uninstalled tool is removed, since it calls the binary by absolute path.
def init-tools [] {
    mkdir ($nu.user-autoload-dirs | first)
    for t in $init_tools {
        let file = (init-file $t.name)
        let installed = (which $t.name | is-not-empty)
        if not $installed {
            rm -f $file
        } else if not ($file | path exists) {
            let out = (run-external $t.name ...$t.args | complete)
            if $out.exit_code == 0 {
                $out.stdout | save $file
            } else {
                print -e $"($t.name) init failed: ($out.stderr | str trim)"
            }
        }
    }
}

def u [] {
    # One failing cask must not skip the gitconfig restore and the rest.
    try {
        brew update
        brew upgrade
        brew upgrade --cask
        brew cleanup
    } catch {|e|
        print -e $"brew failed: ($e.msg)"
    }
    let dotfiles = ("~/.gitconfig" | path expand | path dirname | path dirname)
    let restore = ($dotfiles | path join bootstrap/macos/gitconfig-restore.sh)
    if ($restore | path exists) { bash $restore }
    if (which claude | is-not-empty) { claude update }
    # Upgraded tools may emit different init code; regenerate it.
    $init_tools | each {|t| rm -f (init-file $t.name) } | ignore
    init-tools
}

def greeting [] {
    let time = (date now | format date "%H:%M")
    let host = (sys host | get hostname)
    let pub = try {
        $"pub (ansi green)(http get --max-time 1sec https://ifconfig.me/ip | str trim)(ansi reset)"
    } catch {
        $"pub (ansi red)offline(ansi reset)"
    }
    let lan = (
        sys net
        | each {|i|
            $i.ip
            | where {|a| $a.protocol == "ipv4" and not ($a.address | str starts-with "127.") }
            | each {|a| $"($i.name) (ansi green)($a.address)(ansi reset)" }
        }
        | flatten
    )
    print ([$"(ansi yellow)($time)(ansi reset)" $host $pub ...$lan] | str join "  ")
}

init-tools
greeting
