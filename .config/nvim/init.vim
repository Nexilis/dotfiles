set runtimepath+=$HOME/.config/nvim/vimfiles
set dir=$HOME/.config/nvim/swap//
set backupdir=$HOME/.config/nvim/backup//
set undodir=$HOME/.config/nvim/undo//

let g:plug_shallow=1
call plug#begin('~/.config/nvim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'NLKNguyen/papercolor-theme'
" EasyMotion replacement for nvim >= 0.5, remove pre-extmarks after neovim
" fixes marks coloring
Plug 'phaazon/hop.nvim'
Plug 'ajh17/VimCompletesMe'
Plug 'tpope/vim-commentary'
 " NEXT AND PREVIOUS, LINE OPERATIONS, PASTING, ENCODING AND DECODING, toggles yoh, yob, yow, yos
Plug 'tpope/vim-unimpaired'
Plug 'jiangmiao/auto-pairs'
 " Fix alt key when using Linux
Plug 'drmikehenry/vim-fixkey'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'thaerkh/vim-workspace'
Plug 'brooth/far.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'terryma/vim-expand-region'
Plug 'Yggdroot/indentLine'
Plug 'sbdchd/neoformat'
" defx is a file tree plugin
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
" LSP configuration
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/lsp_extensions.nvim'
" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'
call plug#end()
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

set encoding=utf-8
set langmenu=en_US.utf-8
let $LANG='en_US.utf-8'

if (has("termguicolors"))
  set termguicolors
endif
set background=dark
colorscheme PaperColor
set backup
set swapfile
set undofile
set mousehide
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
command! JsonPrettify :%!python -mjson.tool

let g:mapleader = "\<Space>"
let g:maplocaleader = ','
set timeoutlen=750

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

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction
nmap <leader>t :Defx -split=vertical -winwidth=50 -ignored-files=.git<CR>

nmap <leader>k :bnext<CR>
nmap <leader>j :bprevious<CR>
nmap <leader>q :qa!<CR>
nmap <leader>Ts :setlocal spell! spelllang=en_us<CR>
nmap <leader>Tr :so $MYVIMRC<CR>
nmap <leader>Tj :JsonPrettify<CR>
nmap <leader>Tf :Neoformat<CR>
nmap <leader>Tl :IndentLinesToggle<CR>
nmap <leader>Tw :ToggleWorkspace<CR>
nmap <leader>Ta :ToggleAutosave<CR>

" delete without copying (puts to the balck hole register "_")
nnoremap x "_x
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D

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
nmap <leader>ef :HopWord<CR>
nmap <leader>e1 :HopChar1<CR>
nmap <leader>e2 :HopChar2<CR>
nmap <leader>el :HopLine<CR>
nmap f :HopWord<CR>

" fzf.vim
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump=1
nnoremap <leader>bo :Files<CR>
nnoremap <leader>fc :Rg<CR>
nnoremap <leader>hf :History<CR>
nnoremap <leader>hc :History:<CR>
nnoremap <leader>hs :History/<CR>
" needed for fzf in nvim to include hidden files in search even when FZF_DEFAULT_COMMAND is not set,
" e.g. when nvim is started directly form sh or .desktop file, a place without my configuration
let $FZF_DEFAULT_COMMAND="fdfind -H -t f --no-ignore-vcs"
" Completions in Insert mode using fzf
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-p> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)
" Far plugin
nnoremap <silent> <leader>ff :Farf<cr>
vnoremap <silent> <leader>ff :Farf<cr>
nnoremap <silent> <leader>fr :Farr<cr>
vnoremap <silent> <leader>fr :Farr<cr>
nnoremap <silent> <leader>fd :Fardo<cr>
vnoremap <silent> <leader>fd :Fardo<cr>
nnoremap <silent> <leader>fu :Farundo<cr>
vnoremap <silent> <leader>fu :Farundo<cr>
let g:far#enable_undo=1
" % means currently open file
let g:far#default_file_mask='%'
if has('nvim')
  let g:far#source='rgnvim'
else
  let g:far#source='rg'
endif

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
let g:which_key_map.t = "tree"
let g:which_key_map.T = {
            \ 'name': "+Tools",
            \ 'r':    "config-reload",
            \ 'j':    "json-prettify",
            \ 'l':    "indent-lines-toggle",
            \ 'f':    "autoformat",
            \ 'w':    "workspace-toggle",
            \ 'a':    "autosave-toggle",
            \ 's':    "spellchecker-toggle",
            \}
let g:which_key_map.b = {
            \ 'name': "+buffer",
            \ 'S':    "sudo-write",
            \ 'w':    "write",
            \ 'o':    "open",
            \ 'x':    "close",
            \ 'n':    "new",
            \}
let g:which_key_map.e = {
            \ 'name': "+hop",
            \ 'f':    "word",
            \ 'l':    "line",
            \ '1':    "single-char",
            \ '2':    "two-chars",
            \}
let g:which_key_map.f = {
            \ 'name': "+find-replace",
            \ 'c':    "find-anywhere",
            \ 'f':    "find",
            \ 'r':    "replace",
            \ 'd':    "replace-do",
            \ 'u':    "replace-undo",
            \}
let g:which_key_map.h = {
            \ 'name': "+history",
            \ 'f':    "files",
            \ 'c':    "commands",
            \ 's':    "search",
            \}
let g:which_key_map.w = {
            \ 'name': "+window",
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
            \ 'name': "+syntax",
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

let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='papercolor'

augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Set C# syntax for csx files
autocmd BufNewFile,BufRead *.csx set filetype=cs

lua require('settings')

