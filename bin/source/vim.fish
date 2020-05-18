#!/bin/bash
set KITTY_DEFAULT_OPACITY ( rg 'background_opacity ([0-9\.]*)$' (i root)/config/kitty/kitty.conf -o -r '$1' )
set KITTY_DEFAULT_PADDING ( rg 'window_padding_width (.*)$' (i root)/config/kitty/kitty.conf -o -r '$1' )

function vim 
    if test "$TERM" = "xterm-kitty"
        kitty @set-spacing padding=0 
        kitty @set-background-opacity 1 
    end
    nvim $argv

    if test "$TERM" = "xterm-kitty"
        kitty @set-background-opacity "$KITTY_DEFAULT_OPACITY" 
        kitty @set-spacing padding=$KITTY_DEFAULT_PADDING
    end
end 
