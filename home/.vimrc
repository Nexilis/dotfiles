" put here: ~/_vimrc
set runtimepath+=$HOME/.config/.vim/vimfiles
set dir=$HOME/.config/.vim/swap//
set backupdir=$HOME/.config/.vim/backup//
set undodir=$HOME/.config/.vim/undo//

let g:plug_shallow=1
call plug#begin('~/.config/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'liuchengxu/space-vim-theme'
Plug 'easymotion/vim-easymotion'
Plug 'ajh17/VimCompletesMe'
Plug 'tpope/vim-commentary'
 " NEXT AND PREVIOUS, LINE OPERATIONS, PASTING, ENCODING AND DECODING, toggles yoh, yob, yow, yos
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
" Plug 'terryma/vim-multiple-cursors'
Plug 'liuchengxu/vim-which-key'
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
colorscheme space_vim_theme

command! JsonFormat :%!python -mjson.tool

let g:mapleader = "\<Space>"
let g:maplocaleader = ','
set timeoutlen=500

let g:workspace_create_new_tabs = 0
let g:workspace_session_directory = $HOME . '/.config/.vim/sessions/'
let g:workspace_session_disable_on_args = 1
let g:workspace_undodir = $HOME . '/.config/.vim/.undodir'
" Removing trailing spaces on save causes problems when using vim-multiple-cursors
let g:workspace_autosave_untrailspaces = 0
" Alwasy use autosaving, also outside a session
let g:workspace_autosave_always = 1

nmap <leader>k :bnext<CR>
nmap <leader>j :bprevious<CR>
nmap <leader>q :qa!<CR>
nmap <leader>s :setlocal spell! spelllang=en_us<CR>
nmap <leader>r :so $MYVIMRC<CR>

" Force save as SUDO even if not sudo vim
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
nmap <leader>bS :w!!<CR>
nmap <leader>bw :w!<CR>
nmap <leader>bx :bp <BAR> bd! #<CR>
nmap <leader>bn :enew<CR>

" lines moving based on vim-unimpaired
nmap <M-j> ]e
nmap <M-k> [e

" vim-easymotion
" Disable default mappings
let g:EasyMotion_do_mapping = 0 
let g:EasyMotion_smartcase = 1
nmap <leader>ef <Plug>(easymotion-overwin-w)
nmap <leader>es <Plug>(easymotion-overwin-f2)
nmap <leader>el <Plug>(easymotion-overwin-line)
map <leader>ej <Plug>(easymotion-j)
map <leader>ek <Plug>(easymotion-k)
" replace vim search
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" fzf.vim
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump=1
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Rg<CR>
nnoremap <leader>fh :History<CR>
" File path completion in Insert mode using fzf
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-p> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

" Define prefix dictionary
let g:which_key_map =  {}
let g:which_key_map.k = "buffer-next"
let g:which_key_map.j = "buffer-previous"
let g:which_key_map.q = "quit"
let g:which_key_map.r = "config-reload"
let g:which_key_map.s = "spell-checking"
let g:which_key_map.b = {
            \ 'name': "+buffer",
            \ 'S':    "sudo-write",
            \ 'w':    "write",
            \ 'x':    "buffer-destroy",
            \ 'n':    "buffer-new",
            \}
let g:which_key_map.e = {
            \ 'name': "+easymotion",
            \ 'f':    "goto-word",
            \ 'l':    "goto-line",
            \ 's':    "goto-two-chars",
            \ 'j':    "goto-after-cursor-line",
            \ 'k':    "goto-before-cursor-line",
            \}
let g:which_key_map.f = {
            \ 'name': "+fzf-search",
            \ 'f':    "search-files",
            \ 'b':    "search-text",
            \ 'h':    "search-history",
            \}
" Leader configuration with vim-which-key plugin
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
call which_key#register('<Space>', "g:which_key_map")

let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

augroup which-key-hide-status
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Set C# syntax for csx files
autocmd BufNewFile,BufRead *.csx set filetype=cs
