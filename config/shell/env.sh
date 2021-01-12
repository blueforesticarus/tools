#installed to /etc/profile.d/env.sh and

#source path
source /usr/var/local/tools/root/util/path.env

#variables set once at login
export GOPATH=~/.go

#fzf using fd instead of find
export FZF_DEFAULT_COMMAND='fd --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='dirhist && locations && dirhistglobal'

