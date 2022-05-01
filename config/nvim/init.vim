set runtimepath+=$HOME/.config/nvim/vimfiles

lua require('init')
lua require('plugins')
lua require('keybindings')

" Define prefix dictionary
let g:which_key_map =  {}
let g:which_key_map.k = "buffer-next"
let g:which_key_map.j = "buffer-previous"
let g:which_key_map.q = "quit"
let g:which_key_map.u = "undo-tree-toggle"
let g:which_key_map.t = "file-tree-toggle"
let g:which_key_map.o = {
            \ 'name': "+OPTIONS",
            \ 'r':    "config-reload",
            \ 'f':    "autoformat",
            \ 'w':    "workspace-toggle",
            \ 'a':    "autosave-toggle",
            \ 's':    "spellchecker-toggle",
            \}
let g:which_key_map.b = {
            \ 'name': "+BUFFER",
            \ 'w':    "write",
            \ 'o':    "open",
            \ 'x':    "close",
            \ 'n':    "new",
            \}
let g:which_key_map.h = {
            \ 'name': "+HOP",
            \ 'f':    "word",
            \ 'l':    "line",
            \ '1':    "single-char",
            \ '2':    "two-chars",
            \}
let g:which_key_map.f = {
            \ 'name': "+FIND",
            \ 'f':    "file",
            \ 'g':    "grep-live",
            \ 'b':    "buffers",
            \ 'h':    "help",
            \ 's':    "search-fuzzy",
            \ 'c':    "command-history",
            \}
let g:which_key_map.w = {
            \ 'name': "+WINDOW",
            \ 'q':    "close",
            \ 's':    "split-horizontal",
            \ 'v':    "split-vertical",
            \ 'h':    "focus-left",
            \ 'j':    "focus-down",
            \ 'k':    "focus-up",
            \ 'l':    "focus-right",
            \ 'o':    "only-current-window",
            \}

let g:which_key_map.s = {
            \ 'name': "+SYNTAX",
            \ 'c':    "c#",
            \ 'f':    "f#",
            \ 'j':    "js",
            \ 't':    "ts",
            \ 's':    "json",
            \ 'x':    "xml",
            \ 'b':    "bash",
            \ 'm':    "terraform",
            \ 'r':    "rust",
            \ 'l':    "clojure",
            \}

call which_key#register('<Space>', "g:which_key_map")

augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Set C# syntax for csx files
autocmd BufNewFile,BufRead *.csx set filetype=cs

