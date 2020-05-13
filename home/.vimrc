" put here: ~/_vimrc
set runtimepath+=$HOME/.config/.vim/vimfiles
set dir=$HOME/.config/.vim/swap//
set backupdir=$HOME/.config/.vim/backup//
set undodir=$HOME/.config/.vim/undo//

let g:plug_shallow=1
call plug#begin('~/.config/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'NLKNguyen/papercolor-theme'
Plug 'easymotion/vim-easymotion'
Plug 'ajh17/VimCompletesMe'
Plug 'tpope/vim-commentary'
 " NEXT AND PREVIOUS, LINE OPERATIONS, PASTING, ENCODING AND DECODING
Plug 'tpope/vim-unimpaired'
Plug 'jiangmiao/auto-pairs'
Plug 'guns/vim-clojure-static'
Plug 'OrangeT/vim-csharp'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
Plug 'PProvost/vim-ps1'
 " Fix alt key when using Linux
Plug 'drmikehenry/vim-fixkey'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'thaerkh/vim-workspace'
Plug 'terryma/vim-multiple-cursors'
call plug#end()

set encoding=utf-8
set langmenu=en_US.utf-8
let $LANG='en_US.utf-8'

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
set relativenumber
set autoread
set colorcolumn=120
set hidden
set clipboard^=unnamed,unnamedplus
set background=dark
colorscheme PaperColor

command! JsonFormat :%!python -mjson.tool

let g:workspace_create_new_tabs = 0
let g:workspace_session_directory = $HOME . '/.config/.vim/sessions/'
let g:workspace_session_disable_on_args = 1
let g:workspace_undodir = $HOME . '/.config/.vim/.undodir'
" Removing trailing spaces on save causes problems when using vim-multiple-cursors
let g:workspace_autosave_untrailspaces = 0
" Alwasy use autosaving, also outside a session
let g:workspace_autosave_always = 1

nmap  <C-k> :bnext<CR>
nmap  <C-j> :bprevious<CR>
nmap  <C-F4> :bp <BAR> bd! #<CR>
nmap  <C-x> :bp <BAR> bd! #<CR>
nmap  <C-n> :enew<CR>
" Ctrl+Del in insert mode removes next part of a word
omap <C-Del> <ESC>lvedi

" lines moving based on vim-unimpaired
nmap <M-j> ]e
nmap <M-k> [e
vmap <M-j> ]egv
vmap <M-k> [egv

map <F4> :qa!<CR>
map <F5> :setlocal spell! spelllang=en_us<CR>

nmap f <Plug>(easymotion-overwin-w)
nmap <M-l> <Plug>(easymotion-overwin-line)

nmap <silent> <M-x> :nohlsearch<CR>
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" fzf.vim
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump=1
nnoremap <C-t> :Files<CR>
nnoremap <M-f> :Rg<CR>
nnoremap <C-p> :History<CR>
" File path completion in Insert mode using fzf
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-p> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Set C# syntax for csx files
autocmd BufNewFile,BufRead *.csx set filetype=cs
