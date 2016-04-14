" Welcome to…
"
" I N I T . V I M
"
" “ 𝘞𝘩𝘦𝘳𝘦 𝘴𝘱𝘢𝘳𝘦 𝘵𝘪𝘮𝘦 𝘨𝘰𝘦𝘴 𝘵𝘰 𝘥𝘪𝘦.™ ”

"""""""""""""""""""""
" Environment setup "
"""""""""""""""""""""

" First, make sure we know where to store our stuff.

if !exists('$XDG_CONFIG_HOME')
    let $XDG_CONFIG_HOME=glob('$HOME').'/.config/'
    echo '$XDG_CONFIG_HOME is unset, defaulting to '.glob('$XDG_CONFIG_HOME')
endif

if !exists('$XDG_DATA_HOME')
    let $XDG_DATA_HOME=glob('$HOME').'/.local/share/'
    echo '$XDG_DATA_HOME is unset, defaulting to '.glob('$XDG_DATA_HOME')
endif

" Make sure said stuff actually ends up somewhere.

silent !mkdir -p "$XDG_CONFIG_HOME"
silent !mkdir -p "$XDG_DATA_HOME"

set runtimepath=$XDG_CONFIG_HOME/nvim,$XDG_DATA_HOME/nvim,$VIMRUNTIME

"""""""""""""""""""""""""
" vim-plug installation "
"""""""""""""""""""""""""

let g:plug_window = 'topleft new' " Make sure the window shows up in a good spot the first run.

" This is temporarily a mess until vim-plug#104 is resolved.
if empty(glob('$XDG_DATA_HOME/nvim/autoload/plug.vim'))
    echo "Installing vim-plug…"
    silent exec '!curl -fLo '.expand('$XDG_DATA_HOME/nvim/autoload/plug.vim').' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echo "Installed. PlugInstall will run automatically, then restart nvim."
    autocmd VimEnter * PlugInstall
else
    autocmd VimEnter * runtime plugins.vim
endif

"""""""""""
" Plugins "
"""""""""""

" TODO: Move these into plugins.vim (needs: vim-plug#104)
call plug#begin(expand('$XDG_DATA_HOME/nvim/plugged')) " Must use expand(), glob returns empty string if the directory doesn't exist. We know the variable is non-empty by now.

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'embear/vim-localvimrc'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/unite.vim'
Plug 'mhinz/vim-startify'
Plug 'scrooloose/syntastic'
Plug 'ap/vim-css-color'
Plug 'PeterRincker/vim-argumentative'
Plug 'tweekmonster/braceless.vim'
Plug 'guns/xterm-color-table.vim'

if has('nvim')
Plug 'Shougo/deoplete.nvim'
endif

" Syntax
Plug 'rust-lang/rust.vim'
Plug 'keith/tmux.vim'
Plug 'othree/html5.vim'
Plug 'vim-scripts/groovy.vim'
Plug 'nvie/vim-flake8'

" Colors
Plug 'tomasr/molokai'

call plug#end()

"""""""""""""""""""""""
" Basic configuration "
"""""""""""""""""""""""

" Silence the intro message.
set shortmess+=I

" Let me open new files without saving first.
set hidden

" Much easier to reach.
let mapleader=','

" Detect filetypes.
filetype on
filetype plugin on
filetype indent on

" Make everything pretty.
set formatoptions+=rwn1
set formatoptions-=t
set formatoptions-=c
syntax on
set number
set mouse=n " Mouse is for scrolling in normal mode only.
set scrolloff=999 " Enable side-scroller editing.

colorscheme later-this-evening

" Wrapping stuff
set showbreak=↪\ 
set linebreak
set sidescroll=5
set listchars+=precedes:<
set listchars+=extends:>

if has('patch-7.2.315') " Ensure breakindent is around.
    set breakindent
    set breakindentopt=shift:0
endif

" Set up our tab handling.
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2

" Improve searching.
set ignorecase
set smartcase

" Sync the unnamed register with the system clipboard.
set clipboard^=unnamed

" This is good for Makefiles, but that's about it:
command! RealTabs %s-^\(    \)\+-	

""""""""""""
" Mappings "
""""""""""""

" Truncate and quit
command! Tq %d | wq

" Source vimrc
nmap <silent> <Leader>sv :so $MYVIMRC<CR> :echo "Sourced" $MYVIMRC<CR>

" Toggles
nnoremap <Leader>th :set hlsearch! hlsearch?<CR>
nnoremap <Leader>tt :set expandtab! expandtab?<CR>
nnoremap <Leader>tw :set wrap! wrap?<CR>
nnoremap <Leader>tr :set relativenumber! relativenumber?<CR>

" Black-hole characters deleted with x
noremap x "_x

" Fix navigation over line wraps (from http://statico.github.com/vim.html)
nmap j gj
nmap k gk

" Always center lines when jumping to line number (thanks to https://twitter.com/mattboehm/status/316602303312429056)
" (Off for the moment since I have scrolloff set.)
"nnoremap gg ggz.

" Good navigation in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <S-Left>
cnoremap <C-f> <S-Right>

" Only enable the scroll wheel.
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
map <LeftMouse> <Nop>
map <2-LeftMouse> <Nop>
map <C-LeftMouse> <Nop>
map <S-LeftMouse> <Nop>
map <LeftDrag> <Nop>
map <LeftRelease> <Nop>
map <MiddleMouse> <Nop>
map <RightMouse> <Nop>
map <2-RightMouse> <Nop>
map <A-RightMouse> <Nop>
map <S-RightMouse> <Nop>
map <C-RightMouse> <Nop>
map <RightDrag> <Nop>
map <RightRelease> <Nop>

""""""""""""""""
" vim Classic™ "
""""""""""""""""

if !has('nvim')
	set directory=$XDG_DATA_HOME/nvim/swap//
	set backupdir=.,$XDG_DATA_HOME/nvim/backup
	set viminfo+=n$XDG_DATA_HOME/nvim/shada/viminfo

	set nocompatible
	set wildmenu
	set incsearch
	set hlsearch
    set linebreak

    " neovim understands bracketed pastes, so this is only needed here.
	nnoremap <Leader>tp :set paste! paste?<CR>

    " neovim will automatically create the swap directory, but vim will not.
    silent !mkdir -p "$XDG_DATA_HOME/nvim/swap" 
endif

"""""""""""""""
" Workarounds "
"""""""""""""""

" neovim/neovim#2048
if has('nvim')
    nmap <bs> :<c-u>TmuxNavigateLeft<cr>
endif

