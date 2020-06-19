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

"no wrap
set nowrap

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

"show whitespace
set list
set listchars=tab:>\ ,trail:.,extends:>,precedes:<,nbsp:+

"always show one line above and below cursor
set scrolloff=1

"clear search highlight on esc
nnoremap <esc><esc> :nohls <esc>

"syntax highlighting
colorscheme jellybeans "fallback
call RandomScheme()
nnoremap <F8> :call RandomScheme()<CR>:colorscheme<CR>

syntax on
set t_Co=256
set termguicolors
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
cnoremap w!! w !sudo dd of=% >/dev/null

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
inoremap <F24> <Tab>
inoremap <Ctrl-Space> <Esc>
inoremap <Ctrl-'> <Backspace>
inoremap <Enter> <Esc>
nnoremap <Enter> <Esc><Esc>
vnoremap <Enter> <Esc>
inoremap <Shift+Enter> <Enter>

" auto save on focus lost
":au FocusLost * silent! w 
:au FocusLost * w 

" reload rc
command! RC :source $MYVIMRC

" insert date
command! DATE :put =strftime('%c')
command! ENDFILEDATE normal Go<esc>:DATE<CR>o

"select pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
colorscheme "print what colorscheme we are using
