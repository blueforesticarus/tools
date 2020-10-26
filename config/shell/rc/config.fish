set -U fish_greeting
set EDITOR vvim
set VISUAL vvim
#cat ~/.cache/wal/sequences

bind \e\[23\;2~ backward-kill-word
bind \b backward-kill-bigword

source /usr/var/local/tools/root/util/setup.fish
