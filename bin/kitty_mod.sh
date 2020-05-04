#!/bin/bash
#tput smcup
#tput civis
#stty -echo
#tput rmam

kitty @set-spacing padding=0 
kitty @set-background-opacity 1 
nvim $@

OPACITY="$( rg 'background_opacity ([0-9\.]*)$' `i root`/config/kitty/kitty.conf -o -r '$1')"
PADDING=$( rg 'window_padding_width (.*)$' `i root`/config/kitty/kitty.conf -o -r '$1' )
kitty @set-background-opacity "$OPACITY" 
kitty @set-spacing padding="$PADDING" 

#tput rmcup
#tput smam
