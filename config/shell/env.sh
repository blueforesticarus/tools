#installed to /etc/profile.d/env.sh and

#variables set once at login
export GOPATH=/home/user/.cache/go
export QT_SCALE_FACTOR=1
export GDK_DPI_SCALE=0.75

#fzf using fd instead of find
export FZF_DEFAULT_COMMAND='fd --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='dirhist && locations && dirhistglobal'

export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='X:xdgdefault;p:preview-tui;P:preview-tabbed;v:imgview'

