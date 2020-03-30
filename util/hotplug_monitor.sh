#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/phi/.Xauthority

DEFAULT=$( xrandr | grep 'connected primary' | cut -d ' ' -f1 )

function connect(){
    echo "connecting $1"
    xrandr --output $1 --auto --left-of $DEFAULT
}
 
function disconnect(){
    echo "disconnecting $1"
    xrandr --output $1 --off
}
 
function check(){
    xrandr | grep -F "$1 connected" && connect $1
    xrandr | grep -F "$1 connected" || disconnect $1
}

check HDMI1
check HDMI2

source /usr/var/local/tools/root/util/shellrc
wallpaper -w
