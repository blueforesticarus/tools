#!/bin/bash
KITTY_DEFAULT_OPACITY="$( rg 'background_opacity ([0-9\.]*)$' `i root`/config/kitty.conf -o -r '$1')"
KITTY_DEFAULT_PADDING="$( rg 'window_padding_width (.*)$' `i root`/config/kitty.conf -o -r '$1' )"

vim () {
    no_padding nvim
}

no_padding () {
    if [ "$TERM" = "xterm-kitty" ]; then  
        kitty @set-spacing padding=0 
        kitty @set-background-opacity 1 
    fi
    APP="$1"
    shift
    $APP $@

    if [ "$TERM" = "xterm-kitty" ]; then 
        kitty @set-background-opacity "$KITTY_DEFAULT_OPACITY" 
        kitty @set-spacing padding=$KITTY_DEFAULT_PADDING
    fi
}
