#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=/home/phi/.Xauthority

DEFAULT=$( xrandr | grep 'connected primary' | cut -d ' ' -f1 )

function connect(){
    echo "connecting $1"
    if OPEN; then
        xrandr --output $DEFAULT --auto
        xrandr --output $1 --auto --left-of $DEFAULT
    else
        xrandr --output $DEFAULT --off
        xrandr --output $1 --auto 
    fi
}
 
function disconnect(){
    echo "disconnecting $1"
    xrandr --output $1 --off
    if ! OPEN; then 
        bash `i root`/util/lid.sh --closed
    fi
}
 
function check(){
    xrandr | grep -F "$1 connected" && connect $1
    xrandr | grep -F "$1 connected" || disconnect $1
}

OPEN () {
    cat /proc/acpi/button/lid/LID/state | grep open
    return $?
}

check HDMI1
check HDMI2

source /usr/var/local/tools/root/util/shellrc
wallpaper -w
