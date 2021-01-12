#!/bin/bash
mkdir -p /mnt/latest
mount /dev/backup/latest /mnt/latest
rsync ..

sync
umount /mnt/latest
