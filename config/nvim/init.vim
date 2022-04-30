set runtimepath+=$HOME/.config/nvim/vimfiles

let g:plug_shallow=1
call plug#begin('~/.config/nvim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'feline-nvim/feline.nvim', { 'branch': 'develop' }
Plug 'akinsho/bufferline.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'phaazon/hop.nvim'
Plug 'ajh17/VimCompletesMe'
Plug 'terrortylor/nvim-comment' " gcc to toggle comment
Plug 'tpope/vim-unimpaired' " toggles yoh, yob, yow, yos
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim' " dependency of telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'thaerkh/vim-workspace'
Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'terryma/vim-expand-region'
Plug 'kyazdani42/nvim-web-devicons' " file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim' " show | every 4 spaces
Plug 'sbdchd/neoformat'
call plug#end()

let g:mapleader = "\<Space>"
let g:maplocaleader = ','

" Enable basic formatting when a filetype is not found
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

let g:workspace_create_new_tabs = 0
let g:workspace_session_directory = $HOME . '/.config/nvim/sessions/'
let g:workspace_session_disable_on_args = 1
let g:workspace_undodir = $HOME . '/.config/nvim/undo/workspace'
let g:workspace_autosave_untrailspaces = 0
let g:workspace_autosave_always = 1

nmap <leader>t :NvimTreeToggle<CR>
nmap <leader>k :bnext<CR>
nmap <leader>j :bprevious<CR>
nmap <leader>q :qa!<CR>
nmap <leader>os :setlocal spell! spelllang=en_us<CR>
nmap <leader>or :so $MYVIMRC<CR>
nmap <leader>of :Neoformat<CR>
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

" Telescope
nnoremap <leader>bo <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fc <cmd>Telescope command_history<cr>

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

lua require('init')

