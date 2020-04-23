#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/phi/.Xauthority
export PATH=$PATH:/usr/var/local/tools/root/bin/
#TODO, fix the fact that I need to have ^^^these^^^ three lines
# possibly by scrapping the whole shell init system and redoing it from scratch 

open () {
    bash `i root`/util/hotplug_monitor.sh
}

OPEN () {
    cat /proc/acpi/button/lid/LID/state | grep open
    return $?
}
HDMI () {
    test $( xrandr --listactivemonitors | grep -v "eDP1" | wc -l ) -gt 1
    return $?
}

closed () {
    if ! HDMI; then
        sleep 10
        #give user 10 seconds to plug in monitor, in the future it should be a wait with timeout
    fi
    if ! OPEN; then
        if HDMI ; then
            xrandr --output eDP1 --off
        else
            systemctl suspend
        fi
    fi
}

if [ -z "$1" ]; then
    TODO
fi

case $1 in
    --open )
        open
        ;;
    --closed )
        closed
        ;;
esac


