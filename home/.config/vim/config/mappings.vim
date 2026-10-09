let mapleader = " "
let maplocalleader = " "

nnoremap <leader>p :Explore<CR>
nnoremap <C-s> :update<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l


packadd! comment
nmap <leader>/ gcc
xmap <leader>/ gc

nnoremap <leader>ff :FZF<CR>
nnoremap <leader>fg Rg<CR>

if !has('gui_running')
  for k in ['h','j','k','l','c','s','q']
	execute "set <A-".k.">=\e".k
  endfor
  set ttimeoutlen=50
endif

nnoremap <silent> <A-l> :bnext<CR>
nnoremap <silent> <A-h> :bprevious<CR>

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <A-c> :bd<CR>
nnoremap <A-s> <Cmd>vsplit<CR>
nnoremap <A-q> <Cmd>q<CR>
