set nocompatible

filetype plugin indent on
syntax on

set nolist
set relativenumber
set wrap
set scrolloff=10
set sidescrolloff=8
set laststatus=1
set cmdheight=1
set noshowmode
set showmatch
set matchtime=2
set conceallevel=0
set concealcursor=
set lazyredraw
set synmaxcol=300
set pumheight=10
set fillchars=vert:│

highlight VertSplit guifg=#565f89 guibg=NONE ctermbg=NONE

set tabstop=4
set shiftwidth=2
set softtabstop=2
set noexpandtab
set smartindent
set autoindent

set ignorecase
set smartcase
set nohlsearch
set incsearch

set nobackup
set nowritebackup
set noswapfile
" set undofile
" set undodir=~/.vim/undodir
set updatetime=300
set timeoutlen=500
set ttimeoutlen=0
set autoread
set noautowrite
set encoding=utf-8

" if !isdirectory(expand('~/.vim/undodir'))
  " call mkdir(expand('~/.vim/undodir'), 'p')
" endif

set hidden
set noerrorbells
set iskeyword+=-
set path+=**
set selection=exclusive
set mouse=a
if has('clipboard')
  set clipboard=unnamedplus
endif

set wildmenu
set wildmode=longest:full,full
set wildignore+=.DS_Store,*.o,*.obj,*.pyc,*.class,*.jar

set redrawtime=10000
set maxmempattern=20000
silent! set diffopt+=linematch:60
set foldmethod=indent
set foldlevel=99
