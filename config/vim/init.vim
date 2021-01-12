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
"nnoremap <esc><esc> :nohls <esc> "interferes with exiting quickfix, use enter instead 
"
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

inoremap <F24> <Tab>
inoremap <Ctrl-Space> <Esc>
inoremap <Ctrl-'> <Backspace>
nnoremap <silent> <Enter> :nohls <CR>
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
autocmd BufReadPost quickfix nnoremap <buffer><silent> <esc> :q<CR>
"autocmd BufReadPost quickfix nnoremap <buffer><silent> j j:.cc<CR>zOzz:copen<CR>
"autocmd BufReadPost quickfix nnoremap <buffer><silent> k k:.cc<CR>zOzz:copen<CR>
autocmd BufReadPost quickfix nnoremap <buffer><silent> l :.cc<CR>zOzz:copen<CR>
autocmd BufReadPost quickfix nnoremap <buffer><silent> <Shift+Enter> :.cc<CR>zOzz:copen<CR>
inoremap <Shift+Enter> <Enter>
nnoremap <Tab> <C-w><C-w>

" auto save on focus lost
":au FocusLost * silent! w 
au FocusLost * silent! w 
autocmd FocusLost * stopinsert | wall!

" reload rc
command! RC :source $MYVIMRC

" insert date
command! DATE :put =strftime('%c')
command! ENDFILEDATE normal Go<esc>:DATE<CR>o

"select pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
colorscheme "print what colorscheme we are using

"substitute
:nnoremap sw "sye:%s/<C-R>s/
:nnoremap siw "syiw:%s/<C-R>s/
:nnoremap saw "syaw:%s/<C-R>s/
:nnoremap sW "syE:%s/<C-R>s/
:nnoremap siW "syiW:%s/<C-R>s/
:nnoremap saW "syaW:%s/<C-R>s/
:nnoremap ss :%s/<C-R>s/
:nnoremap sp :%s/<C-R>0/
:nnoremap s/ :%s/<C-R>//
:vnoremap s "sy:%s/<C-R>s/

"find
:nnoremap ?w "sye /<C-R>s
:nnoremap ?iw "syiw/<C-R>s
:nnoremap ?aw "syaw/<C-R>s
:nnoremap ?W "syE/<C-R>s
:nnoremap ?iW "syiW/<C-R>s
:nnoremap ?aW "syaW/<C-R>s
:nnoremap ?? /<C-R>/
:nnoremap ?p /<C-R>0
:nnoremap ?s /<C-R>s
:vnoremap ? "sy/<C-R>/

"folds
set foldmethod=indent
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"zj")<CR>
nnoremap <C-h> zm
nnoremap <C-l> zr

"fold magic 
nnoremap zv mazMzv`a
"nnoremap <silent> <space> zj mazMzv`a zz

"close buffer
nnoremap <C-d> :ccl <bar> lcl <bar> UndotreeHide <bar> bd <CR> 

"visual paste
nnoremap gp `[v`]

"move cursor in input/command mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

"no arrow keys in insert mode
"inoremap <Left> <nop>
"inoremap <Right> <nop>
"inoremap <Up> <nop>
"inoremap <Down> <nop>

set cursorline
"autocmd InsertEnter * highlight CursorLine guifg=white guibg=blue ctermfg=white ctermbg=blue
"autocmd InsertLeave * highlight CursorLine guifg=white guibg=darkblue ctermfg=white ctermbg=darkblue
autocmd InsertEnter * set nocul
autocmd InsertLeave * set cul

"highlight inserted text
"highlight Inserted ctermbg=blue guibg=blue
"function! s:AddHighlight() abort   
"    let [_, lnum, col; rest] = getpos('.')
"    let w:insert_hl = matchadd('Inserted', '\%'.col.'c\%'.lnum.'l\_.*\%#') 
"endfunction
"function! s:DeleteHighlight() abort   
"    if exists('w:insert_hl')       
"        call matchdelete(w:insert_hl)   
"    endif 
"endfunction  
"augroup InsertHL   
"    autocmd!   
"    autocmd InsertEnter * call s:AddHighlight()   
"    autocmd InsertLeave * call s:DeleteHighlight() 
"augroup END

"replace
nnoremap <silent> gr :let @/='\<'.expand('<cword>').'\>'<CR>:%s///g<left><left>
xnoremap <silent> gr "sy:let @/=@s<CR>:%s///g<left><left>
nnoremap <silent> sr :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> sr "sy:let @/=@s<CR>cgn
set inccommand=nosplit

" Replace the highlighted matches with whatever you want.
" This places your cursor directly in the replace area of the command.
nnoremap r :%s///g<left><left>

autocmd FileType c,cpp,h setlocal equalprg=clang-format\ -style='\{BasedOnStyle:\ llvm,\ IndentWidth:\ 4\}'

