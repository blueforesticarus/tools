"syntax highlighting for Erich's Annotation Syntax (.eas)

" Quit if  syntax file already loaded
if exists('b:current_syntax') | finish| endif

syntax match Tag /\[[^\[\]]*\]/
syntax match Title /^\s*\[[^\[\]]*\]/
syntax match Comment /#.*$/
syntax match ShellLine /\$\@<=[^#]\+/
syntax match StarStar  /\*\+\w*/ containedin=ALL 
syntax match Important  /\!\+\w*\!/ containedin=ALL 
syntax match ShellShell /\$\+/ containedin=ALL
syntax region Box  start=/#=\+/ end=/##=\+/    
syntax region Note start=/</ end=/>/
syntax match  Header /^[^#.,\[\]]\+:\s*/


hi def Tag ctermfg=Blue
hi def Header cterm=bold
hi def Comment ctermfg=Gray
hi def ShellLine ctermfg=Blue guifg=#0000ff
hi def ShellShell cterm=bold ctermfg=Magenta guifg=#000099
hi def StarStar  ctermfg=Red guifg=#ff0000
"hi def Important  start=<esc>[31;5m stop=<esc>[0m
hi def Important  cterm=bold,undercurl ctermfg=Red
hi def Box   ctermfg=Brown
hi def Note  ctermfg=Yellow

let b:current_syntax = 'eas'


