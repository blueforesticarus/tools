"simple vimrc, complex config in dot/vim/.vimrc_extra
"author: Erich Spaker, Feb 2020
source ~/.config/nvim/extra.vim

"disable vi compatibility mode
set nocompatible

"buffers
set hidden

"format
set fileformat=unix
set encoding=utf-8

"enable mouse
set mouse=a

"reduce timeouts to eliminate noticable delay
set ttimeoutlen=10 "escape delay
set notimeout "wait indefinately for key sequences

"tab settings
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent

"makefiles need tabs not spaces
autocmd FileType make setlocal noexpandtab

"hybrid line numbers
set number relativenumber

"enable status bar
set laststatus=2

"open split panes to the right/bottom
set splitright
set splitbelow

"search highlighting
set incsearch
set hlsearch

"clear search highlight on esc
nnoremap <esc><esc> :nohls <esc>

"syntax highlighting
syntax on
colorscheme jellybeans
set t_Co=256
highlight Normal ctermbg=Black
highlight NonText ctermbg=Black
let &t_ut=''
set background=dark

"persistent undo
set undodir=~/.vim/undo
set undofile

"backspace works like most editors in insert
set backspace=indent,eol,start

"easier mappings for beggining and end of line
nnoremap m $
nnoremap M ^
vnoremap m $
vnoremap M ^

"exiting insert mode does not move cursor
autocmd InsertLeave * :normal `^
set virtualedit=onemore "allow cursor to hang off end of line in normal mode

"easier commands
vnoremap ; :
nnoremap ; :

"command to save with sudo
command W :w !sudo tee %:t >/dev/null

"default paste from yank buffer
"vnoremap p "0p
"nnoremap p "0p
"nnoremap P "0P
"nnoremap P "0P

"vnoremap x "0x
"nnoremap x "0x

"based on my understanding of vim keybinds these should not be needed
"but for some reason they are. Vim really needs a complete keybind overhaul.
"The way it works is hacky garbage
"vnoremap ""p p
"nnoremap ""p p
"nnoremap ""P P
"nnoremap ""P P

" tab switches to normal mode for one command
inoremap <Tab> <C-o>
inoremap <F24> <Enter>
inoremap <Ctrl-Space> <Esc>
inoremap <Ctrl-'> <Backspace>

" auto save on focus lost
:au FocusLost * silent! w 

" insert date
command DATE :put =strftime('%c')
command ENDFILEDATE normal Go<esc>:DATE<CR>o

"select pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

