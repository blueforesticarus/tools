D=`dirname "$(readlink -f "$0")"`
D=`realpath "$D"`
echo "root: $D"
source $D/util/shellrc
yesno -Y "Continue?"

sudo chmod +x $D/bin/*
sudo i root "`realpath $D`"

mkdir -p "$D"/data/ip
touch "$D"/data/ip/list #TODO iplist or conn or avail should do this, not setup

issym () {
    if [ -e "$1" ] && [ "A`realpath $1`" ==  "A`realpath $2`" ]; then
        return 0
    else
        return 1
    fi
}

if yesno -N "Symlink to tools/bin"; then
    
    read -e -p "Symlink location: " -i "~/.tools" SYM 
    SYM=${SYM/#\~/$HOME}
    ln -s -Tf "$D/bin" $SYM
fi

rc () {
    if ! [ -f $1 ]; then
        return 
    fi

    TAG="#ADDED BY TOOLS SETUP.SH"
    S="source $D/util/shellrc #ADDED BY TOOLS SETUP.SH"
        
    if ! grep -F "$S" $1; then
        echo "You need to add this line to your $1:"
        echo "    $S"
        
        if yesno -Y "Add automatically?" ; then
            tmp=`mktemp`
            grep -v -F "$TAG" $1 > $tmp
            echo "$S" >> $tmp
            mv $tmp $1
        fi
    fi
}
    
takeover(){
    if ! issym "$1" "$2"; then
        if yesno -N "Take Over $1 ?" ; then
            if [ -e "$1" ]; then
                mv "$1" "$1".old
            fi

            if [ -L "$1" -a ! -e "$1" ]; then 
                rm "$1" 
            fi

            ln -snf "$2" "$1" 
            return 0
        else
            return 1
        fi
    else 
        return 0
    fi
}


takeover ~/.zshrc $D/config/zshrc || rc ~/.zshrc
takeover ~/.vimrc $D/config/vimrc
takeover ~/.vim $D/config/vim 
takeover ~/.config/kitty $D/config/kitty
takeover ~/.i3 $D/config/i3
takeover ~/.config/rofi/config $D/config/rofi.conf

rc ~/.profile
rc ~/.bashrc

cd extern
bash external.sh

git submodule init
git submodule update
