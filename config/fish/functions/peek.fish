function peek --description 'Show lines of a file, redrawn when it changes'
    if test (count $argv) -lt 1
        echo 'usage: peek <file> [lines or start:end, default 50]' >&2
        return 1
    end
    set -l f $argv[1]
    set -l r :50
    if test (count $argv) -ge 2
        set r $argv[2]
        string match -q '*:*' -- $r; or set r :$r
    end
    if not test -f $f
        echo "peek: no such file: $f" >&2
        return 1
    end
    set -l last
    while true
        set -l m (stat -f %m $f)
        if test "$m" != "$last"
            printf '\e[H\e[2J\e[3J'
            bat -p --paging=never --color=always -r $r $f
            set last $m
        end
        sleep 1
    end
end
