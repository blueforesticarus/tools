"syntax highlighting for Erich's Annotation Syntax (.eas)

" Quit if  syntax file already loaded
if exists('b:current_syntax') | finish| endif

syntax match Tag /\[[^\[\]]*\]/
syntax match Title /^\s*\[[^\[\]]*\]/
syntax match Comment /#.*$/
syntax match ShellLine /\$\@<=[^#]\+/
syntax match StarStar  /[\*\$]\+/ containedin=ALL 
syntax region Box  start=/#=\+/ end=/##=\+/    

hi def Tag ctermfg=Blue
hi def Header ctermfg=Red
hi def Comment ctermfg=Gray
hi def ShellLine ctermfg=Blue guifg=#0000ff
hi def StarStar  ctermfg=Red guifg=#ff0000
hi def Box   ctermfg=Brown

let b:current_syntax = 'eas'


