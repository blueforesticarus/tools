#!/bin/bash
checkupdates -d

NPKGS=$(checkupdates | wc -l)
PKGTXT="$(checkupdates)"

if [ $NPKGS != 0 ]; then 
    /usr/var/local/tools/root/bin/notify pacman update "$NPKGS" "$PKGTXT"
fi
