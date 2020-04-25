D=`dirname "$(readlink -f "$0")"`
D=`realpath "$D"`
echo "root: $D"
source $D/util/shellrc
cd $D

LREV="`trim $(config "commit")`"
CREV="`git rev-parse --verify HEAD`"
if [ ! -z "$LREV" ] && [ "$LREV" != "$CREV" ]; then 
    git log $LREV..
fi

yesno -Y "Continue?"

mkdir -p $D/data/
if [ "$1" = "-C" ]; then
    rm -f $D/data/setup
fi
touch $D/data/setup
config () {
    grep "`printf '^%s ' "$1"`" $D/data/setup | cut -d ' ' -f2-
    return ${PIPESTATUS[0]}
}
setconf () {
    grep -v "`printf '^%s ' "$1"`" $D/data/setup > $D/data/setup.1
    printf "%s %s\n" "$1" "$2" >> $D/data/setup >> $D/data/setup.1
    mv $D/data/setup.1 $D/data/setup
}
setnoconf (){
    grep -v "`printf '^%s ' "$1"`" $D/data/setup > $D/data/setup.1
    mv $D/data/setup.1 $D/data/setup
}

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

symlinktobin () {
    if yesno -N "Symlink to tools/bin"; then
        read -e -p "Symlink location: " -i "~/.tools" SYM 
        SYM=${SYM/#\~/$HOME}
        ln -s -Tf "$D/bin" $SYM
        setconf symbinloc "$SYM"
        setconf symbin 1
    else
        setnoconf symbinloc
        setconf symbin 0
    fi
}

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
        if [ "`config "$2"`" == "0" ]; then
            echo "Skipping disabled: $1 => $2" >&2
            return 0
        fi
        if yesno -N "Take Over $1 ?" ; then
            if [ -e "$1" ]; then
                $3 mv "$1" "$1".old
            fi

            if [ -L "$1" -a ! -e "$1" ]; then 
                $3 rm "$1" 
            fi

            $3 ln -snf "$2" "$1" 
            setconf "$2" 1
            return 0
        else
            setconf "$2" 0
            return 1
        fi
    else 
        setconf "$2" 1
        return 0
    fi
}


if ! config symbin > /dev/null; then
    symlinktobin
elif [ `config symbin` -ne 0 ]; then
    SYM="`config symbinloc`"
    if ! takeover "$SYM" $D/bin; then 
        setnoconf symbin
        setnoconf symbinloc
        symlinktobin
    fi
    setnoconf $D/bin
else
    echo "Skipping disabled: symlink to bin"
fi

takeover ~/.zshrc $D/config/zshrc || rc ~/.zshrc
takeover ~/.vimrc $D/config/vimrc
takeover ~/.vim $D/config/vim 
takeover ~/.config/nvim $D/config/nvim
takeover ~/.config/kitty $D/config/kitty
takeover ~/.i3 $D/config/i3
takeover ~/.config/rofi/config $D/config/rofi.conf
takeover ~/.local/share/applications $D/config/desktop
takeover ~/.config/dunst/dunstrc $D/config/dunstrc
takeover ~/.config/qutebrowser $D/config/qute

takeover ~/.config/spotifyd/spotifyd.conf $D/config/spotifyd.conf

#udev
takeover /etc/udev/rules.d/95-monitor-hotplug.rules $D/config/udev/95-monitor-hotplug.rules sudo 
takeover /etc/udev/rules.d/99-batify.rules $D/config/udev/99-batify.rules sudo 
takeover /etc/acpi/handler.sh $D/config/acpi.sh sudo 

#systemd
takeover ~/.config/systemd/user/spotifyd.service $D/config/service/spotifyd.service
takeover ~/.config/systemd/user/conky.service $D/config/service/conky.service
takeover ~/.config/systemd/user/dunst.service $D/config/service/dunst.service
systemctl --user daemon-reload

AAA=/usr/var/local/spotifyd/cache
if [ ! -d "$AAA" ];then
    sudo mkdir -p $AAA
    sudo chmod 777 $AAA
fi


mkdir -p data/
echo "PATH=$PATH" > data/path.env
takeover ~/.config/environment.d/path.conf $D/data/path.env

rc ~/.profile
rc ~/.bashrc

git submodule init
git submodule update

bash extern/external.sh

setconf "commit" "`git rev-parse --verify HEAD`"

echo 
make
