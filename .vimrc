"setting and colorscmemes 
set number
set backspace=2
syntax on
set tabstop=4
set background=dark
set fileformat=unix
set t_Co=256
colorscheme gruvbox
set laststatus=2
set mouse=a
"Binds go here
inoremap <C-S> <Esc> :update<CR>
noremap <C-S> :update<CR>
nmap <C-j> LjM
nmap <C-k> HkM

"magic
noremap <C-Z> "kyiw :vnew sview \| 0read ! zs <C-r>k <CR><CR> <C-w>r :setlocal buftype=nofile<CR> <C-w><C-h> 
