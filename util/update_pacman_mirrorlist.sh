#!/bin/bash
reflector --protocol https --f 13 --score 35 --age 12 -c US --save /etc/pacman.d/mirrorlist
