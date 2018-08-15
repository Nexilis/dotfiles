" put here: ~/_vimrc
set runtimepath+=$HOME/.config/.vim/vimfiles
set dir=$HOME/.config/.vim/swap//
set backupdir=$HOME/.config/.vim/backup//
set undodir=$HOME/.config/.vim/undo//

let g:plug_shallow=1 " Download shallow copy of plugins
call plug#begin('~/.config/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'NLKNguyen/papercolor-theme'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'ajh17/VimCompletesMe'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired' " NEXT AND PREVIOUS, LINE OPERATIONS, PASTING, ENCODING AND DECODING
Plug 'jiangmiao/auto-pairs'
Plug 'guns/vim-clojure-static'
Plug 'OrangeT/vim-csharp'
Plug 'PProvost/vim-ps1'
Plug 'drmikehenry/vim-fixkey' " Fix alt key when using Linux
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
set clipboard=unnamedplus
set background=dark
colorscheme PaperColor

command! JsonFormat :%!python -mjson.tool

noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>
map  <C-Tab> :bnext<CR>
map  <C-S-Tab> :bprevious<CR>
map  <C-F4> :bp <BAR> bd! #<CR>
map  <C-x> :bp <BAR> bd! #<CR>
map  <C-n> :enew<CR>
map  <C-p> :browse oldfiles<CR>
imap <C-Del> <ESC>lvedi " Ctrl+Del in insert mode removes next part of a word

" lines moving based on vim-unimpaired
nmap <M-j> ]e
nmap <M-k> [e
vmap <M-j> ]egv
vmap <M-k> [egv

map <F4> :q!<CR>
map <F5> :setlocal spell! spelllang=en_us<CR>

map  <M-f> <Plug>(easymotion-bd-f)
nmap <M-f> <Plug>(easymotion-overwin-f)
nmap <M-s> <Plug>(easymotion-overwin-f2)
map  <M-l> <Plug>(easymotion-bd-jk)
nmap <M-l> <Plug>(easymotion-overwin-line)
map  <M-w> <Plug>(easymotion-bd-w)
nmap <M-w> <Plug>(easymotion-overwin-w)

map  <C-t> :NERDTreeToggle<CR>
map  <M-t> :lcd %:p:h<CR> :NERDTreeFind<CR> " Set working directory to current file dir and sync NERDTree view
nmap <silent> <M-x> :nohlsearch<cr> " Clean search (highlight)
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

autocmd BufNewFile,BufRead *.csx set filetype=cs " Set C# syntax for csx files
