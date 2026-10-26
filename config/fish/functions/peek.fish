function peek --description 'Show the top lines of a file, redrawn when it changes'
    if test (count $argv) -lt 1
        echo 'usage: peek <file> [lines, default 50]' >&2
        return 1
    end
    set -l f $argv[1]
    set -l n 50
    test (count $argv) -ge 2; and set n $argv[2]
    if not test -f $f
        echo "peek: no such file: $f" >&2
        return 1
    end
    set -l last
    while true
        set -l m (stat -f %m $f)
        if test "$m" != "$last"
            printf '\e[H\e[2J\e[3J'
            bat -p --paging=never --color=always -r :$n $f
            set last $m
        end
        sleep 1
    end
end
