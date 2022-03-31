set runtimepath+=$HOME/.config/nvim/vimfiles
set dir=$HOME/.config/nvim/swap//
set backupdir=$HOME/.config/nvim/backup//
set undodir=$HOME/.config/nvim/undo//

let g:plug_shallow=1
call plug#begin('~/.config/nvim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'Olical/aniseed' " Neovim configuration and plugins in Fennel (Lisp compiled to Lua)
Plug 'Olical/conjure' " Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
Plug 'feline-nvim/feline.nvim', { 'branch': 'develop' }
Plug 'akinsho/bufferline.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'phaazon/hop.nvim'
Plug 'ajh17/VimCompletesMe'
Plug 'terrortylor/nvim-comment' " gcc to toggle comment
Plug 'tpope/vim-unimpaired' " toggles yoh, yob, yow, yos
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'thaerkh/vim-workspace'
Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'terryma/vim-expand-region'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'Yggdroot/indentLine'
Plug 'sbdchd/neoformat'
" LSP configuration
Plug 'neovim/nvim-lspconfig' " common configs for nvim LSP client
Plug 'nvim-lua/lsp_extensions.nvim' " LSP extensions, e.g. providing type inlay hints
Plug 'nvim-lua/completion-nvim' " LSP autocompletion framework
call plug#end()
" Set completeopt to have a better completion experience - :help completeopt
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

set termguicolors
set encoding=utf-8
set langmenu=en_US.utf-8
let $LANG='en_US.utf-8'

set background=dark
colorscheme PaperColor
set backup
set swapfile
set undofile
set mousehide
" enable mouse scroll
set mouse=a
set nowrap
set backspace=2
set textwidth=0
set wrapmargin=0
set formatoptions-=t
set hlsearch
set ignorecase
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set laststatus=2
set path+=**
set wildmenu
set wildignore+=*/tmp/*,*.so,*.swp,*.
set number
set autoread
set colorcolumn=120
set hidden
set clipboard^=unnamed,unnamedplus
set listchars=tab:→\ ,trail:·,nbsp:·,space:·
set list
let g:indentLine_char = '┊'

let g:mapleader = "\<Space>"
let g:maplocaleader = ','
set timeoutlen=500

" Enable basic formatting when a filetype is not found
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

let g:workspace_create_new_tabs = 0
let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/'
let g:workspace_session_disable_on_args = 1
let g:workspace_undodir = $HOME . '/.config/nvim/undo/workspace'
" Removing trailing spaces on save causes problems when using vim-multiple-cursors
let g:workspace_autosave_untrailspaces = 0
" Alwasy use autosaving, also outside a session
let g:workspace_autosave_always = 1

nmap <leader>t :NvimTreeToggle<CR>

nmap <leader>k :bnext<CR>
nmap <leader>j :bprevious<CR>
nmap <leader>q :qa!<CR>
nmap <leader>os :setlocal spell! spelllang=en_us<CR>
nmap <leader>or :so $MYVIMRC<CR>
nmap <leader>of :Neoformat<CR>
nmap <leader>ol :IndentLinesToggle<CR>
nmap <leader>ow :ToggleWorkspace<CR>
nmap <leader>oa :ToggleAutosave<CR>

" delete without copying (puts to the black hole register "_")
nnoremap x "_x
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D

" CTRL+Z working in insert mode
inoremap <c-z> <c-o>:u<CR>
" CTRL+V, CTRL+SHIFT+V working in insert mode
inoremap <c-v> <esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>mi`[=`]`ia
inoremap <c-s-v> <esc>:set paste<cr>a<c-r>=getreg('+')<cr><esc>:set nopaste<cr>mi`[=`]`ia

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>

" Force save as SUDO even if not sudo vim
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
nmap <leader>bS :w!!<CR>
nmap <leader>bw :w!<CR>
nmap <leader>bx :bp <BAR> bd! #<CR>
nmap <leader>bn :enew<CR>

" lines moving based on vim-unimpaired
nmap <M-j> ]e
nmap <M-k> [e

" vim-expand-region
map + <Plug>(expand_region_expand)
map _ <Plug>(expand_region_shrink)

" phaazon/hop.nvim
nmap <leader>hf :HopWord<CR>
nmap <leader>h1 :HopChar1<CR>
nmap <leader>h2 :HopChar2<CR>
nmap <leader>hl :HopLine<CR>
nmap f :HopWord<CR>

" fzf.vim
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump=1
nnoremap <leader>f :Rg<CR>
nnoremap <leader>bo :Files<CR>
nnoremap <leader>if :History<CR>
nnoremap <leader>ic :History:<CR>
nnoremap <leader>is :History/<CR>
" needed for fzf in nvim to include hidden files in search even when FZF_DEFAULT_COMMAND is not set,
" e.g. when nvim is started directly form sh or .desktop file, a place without my configuration
let $FZF_DEFAULT_COMMAND="fd -H -t f --no-ignore-vcs"
" Completions in Insert mode using fzf
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-p> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

" window mappings
nnoremap <leader>wq <C-w>q
nnoremap <leader>ws :split<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader>wo :only<cr>
nnoremap <leader>wh <C-w>h
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l

" Define prefix dictionary
let g:which_key_map =  {}
let g:which_key_map.k = "buffer-next"
let g:which_key_map.j = "buffer-previous"
let g:which_key_map.q = "quit"
let g:which_key_map.u = "undo-tree-toggle"
let g:which_key_map.t = "file-tree-toggle"
let g:which_key_map.f = "find-everywhere"
let g:which_key_map.o = {
            \ 'name': "+TOOLS",
            \ 'r':    "config-reload",
            \ 'l':    "indent-lines-toggle",
            \ 'f':    "autoformat",
            \ 'w':    "workspace-toggle",
            \ 'a':    "autosave-toggle",
            \ 's':    "spellchecker-toggle",
            \}
let g:which_key_map.b = {
            \ 'name': "+BUFFER",
            \ 'S':    "sudo-write",
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
let g:which_key_map.i = {
            \ 'name': "+HISTORY",
            \ 'f':    "files",
            \ 'c':    "commands",
            \ 's':    "search",
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

" Syntax
nnoremap <leader>sc :set syn=cs<CR>
nnoremap <leader>sf :set syn=fsharp<CR>
nnoremap <leader>sj :set syn=javascript<CR>
nnoremap <leader>st :set syn=typescript<CR>
nnoremap <leader>ss :set syn=json<CR>
nnoremap <leader>sx :set syn=xml<CR>
nnoremap <leader>sb :set syn=sh<CR>
nnoremap <leader>sm :set syn=terrafrom<CR>
nnoremap <leader>sr :set syn=rust<CR>
nnoremap <leader>sl :set syn=clojure<CR>
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

" Leader configuration with vim-which-key plugin
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
call which_key#register('<Space>', "g:which_key_map")

augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Set C# syntax for csx files
autocmd BufNewFile,BufRead *.csx set filetype=cs

lua require('settings')

