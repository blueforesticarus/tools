execute pathogen#infect('plugins/{}')
execute pathogen#infect('extra_colors/{}')

"XXX not used
function! s:color_override()
	let color = system('ls ~/.vim/colors | head -1 | xargs basename -s .vim | grep -v _unused')
	if color != ""
		execute "colorscheme ".color
	endif
endfunction
"XXX call s:color_override() "if there is a colorscheme in .vim/colors it is used

function! RandomNumber(limit) 
  let components = split(reltimestr(reltime()), '\.')
  let microseconds = components[-1] + 0
  return microseconds % a:limit
endfunction

function! RandomScheme() 
  let choices = []
  for fname in split(globpath(&runtimepath, 'colors/*.vim'), '\n')
    let name = fnamemodify(fname, ':t:r')
    let choices = choices + [name]
  endfor
  let index = RandomNumber(len(choices))
  execute 'colorscheme' fnameescape(choices[index])
endfunction

call RandomScheme()
nnoremap <F8> :call RandomScheme()<CR>:colorscheme<CR>
"airline extensions

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

"delete does not delete newlines in normal mode
function! Delete_key(...)
  let line=getline (".")
  if line=~'^\s*$'
    execute "normal dd"
    return
  endif
  let column = col(".")
  let line_len = strlen (line)
  let first_or_end=0
  if column == 1
    let first_or_end=1
  else
    if column == line_len
      let first_or_end=1
    endif
  endif
  execute "normal i\<DEL>\<Esc>"
  if first_or_end == 0
    execute "normal l"
  endif
endfunction
nnoremap <silent> <DEL> :call Delete_key()<CR>

"syntax highlighting for eas 
autocmd BufNewFile,BufRead *.eas setf eas

  let g:ctrlp_show_hidden = 0"syntax highlight for box comments.
au FileType * syntax region Box  start=/#=\+/ end=/##=\+/ | hi def Box ctermfg=Brown

"generate comment box
nnoremap ,co ^v$h"by<Esc>O#<Esc>100A=<Esc>100\|D<CR>i#<CR><Esc>i##<Esc>100a=<Esc>100\|D<Esc>kA <Tab><Tab><Tab><Tab><Tab><Esc>"bp`[i

"moving selections aroung
vnoremap <C-j> :m '>+1<CR>gv
vnoremap <C-k> :m '<-2<CR>gv
vnoremap <C-l> > gv
vnoremap <C-h> < gv

"adding lines above/below
vnoremap <C-i> <ESC>O<ESC>gv
vnoremap <C-o> <ESC>o<ESC>gv

"scroll, courtesy of Frederick Phillip Frey III (circa 2019 A.D.)
nnoremap <C-j> LjM
nnoremap <C-k> HkM

"auto relative line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"ctrlp keybinds
let g:ctrlp_map = '<C-p>'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden = 0

nnoremap f :CtrlPBuffer<CR>
nnoremap <C-f> :CtrlPMixed<CR>
nnoremap F :CtrlPCurFile<CR>

"ctrlp filters
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v(\.git|\.hg|\.svn|build)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ } 

"newline in normal
nnoremap J i<CR><ESC>
"remove newline
nnoremap K J

"ripgrep config
let g:rg_command = 'rg --vimgrep -S'
nnoremap <C-c> :ccl <bar> lcl <bar> UndotreeHide <CR>
nnoremap U <C-r>
nnoremap <C-r> :Rg <CR>
vnoremap <C-r> "ry :Rg -F "<C-r>""<CR>

"undotree
nnoremap <F5> :UndotreeToggle<cr>

"syntastic
let python_highlight_all=1
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

nnoremap gl :lopen<CR>
nnoremap gk :lclose<CR>

let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1

"rust settings
let g:rustfmt_autosave = 1

nnoremap <C-e> :lopen <CR>
nnoremap ze :Errors <CR> :ll<CR> zO :ll<CR>
"todo setup ale instead of syntastic

let g:livepreview_previewer = 'zathura'

"taglist
nnoremap <silent> <F9> :TlistToggle<CR>
nnoremap <Tab> <C-w><C-w>

"maximiser
nnoremap <silent>zf :MaximizerToggle<CR>

