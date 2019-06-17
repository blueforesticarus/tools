"syntax highlighting for Erich's Annotation Syntax (.eas)

" Quit if  syntax file already loaded
if exists('b:current_syntax') | finish| endif

syntax match Tag /\[[^\[\]]*\]/
syntax match Title /^\s*\[[^\[\]]*\]/
"syntax match Comment 
"syntax match shell   
"syntax match star    ""
"syntax match box     ""

hi def Tag ctermfg=Red guifg=#ff0000
hi def Header ctermfg=Blue guifg=#0000ff
"hi def shell   Identifier
"hi def star    Identifier
"hi def box     Identifier

let b:current_syntax = 'eas'


