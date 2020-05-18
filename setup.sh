D=`dirname "$(readlink -f "$0")"`
D=`realpath "$D"`
source $D/util/shellrc
cd $D

if [ -z "`$D/bin/i var`" ]; then 
    read -p "Path for var dir: " -i "./data" -e LINE
    mkdir -p "$LINE" || exit 1
    sudo $D/bin/i var $LINE
fi
VAR="`$D/bin/i var`"

chmod +w $VAR/setup
config () {
    grep "`printf '^%s ' "$1"`" $VAR/setup | cut -d ' ' -f2-
    return ${PIPESTATUS[0]}
}

LREV="$(config "commit")"
CREV="`git rev-parse --verify HEAD`"
if [ -f $VAR/setup ] && [ ! -z "$LREV" ] && [ "$LREV" != "$CREV" ]; then 
    git log $LREV..
fi

echo "root: $D"
yesno -Y "Continue?"

mkdir -p $VAR/
if [ "$1" = "-C" ]; then
    rm -f $VAR/setup
fi
touch $VAR/setup
setconf () {
    grep -v "`printf '^%s ' "$1"`" $VAR/setup > $VAR/setup.1
    printf "%s %s\n" "$1" "$2" >> $VAR/setup >> $VAR/setup.1
    mv $VAR/setup.1 $VAR/setup
}
setnoconf (){
    grep -v "`printf '^%s ' "$1"`" $VAR/setup > $VAR/setup.1
    mv $VAR/setup.1 $VAR/setup
}

sudo chmod +x $D/bin/*
sudo i root "`realpath $D`"

mkdir -p $VAR/ip
touch $VAR/ip/list #TODO iplist or conn or avail should do this, not setup

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


#takeover ~/.zshrc $D/config/zshrc || rc ~/.zshrc
takeover ~/.vimrc $D/config/vimrc

rm -rf $D/config/vim/undo 
takeover ~/.vim $D/config/vim && ln -snf "`i var`"/vim/undo $D/config/vim

#config
takeover ~/.config/nvim               $D/config/nvim
takeover ~/.config/kitty              $D/config/kitty
takeover ~/.i3                        $D/config/i3
takeover ~/.config/rofi/config        $D/config/rofi.conf
takeover ~/.config/dunst/dunstrc      $D/config/dunstrc
takeover ~/.config/qutebrowser        $D/config/qute
takeover ~/.config/spotifyd/spotifyd.conf $D/config/spotifyd.conf
takeover ~/.local/share/applications  $D/desktop

#autologin
takeover ~/.xinitrc  $D/config/xinitrc
takeover ~/.profile  $D/config/shell/profile
takeover /etc/profile.d/env.sh  $D/config/shell/env.sh sudo

#udev
takeover /etc/udev/rules.d/95-monitor-hotplug.rules $D/udev/95-monitor-hotplug.rules sudo 
takeover /etc/udev/rules.d/99-batify.rules          $D/udev/99-batify.rules          sudo 
takeover /etc/acpi/handler.sh                       $D/config/acpi.sh                sudo 

#systemd
takeover ~/.config/systemd/user/spotifyd.service    $D/service/spotifyd.service
takeover ~/.config/systemd/user/conky.service       $D/service/conky.service
takeover ~/.config/systemd/user/compton.service     $D/service/compton.service
takeover ~/.config/systemd/user/dunst.service       $D/service/dunst.service
takeover ~/.config/systemd/user/i3focuslast.service $D/service/i3focuslast.service
takeover ~/.config/systemd/user/i3.service          $D/service/i3.service
takeover ~/.config/systemd/user/xsession.target     $D/service/xsession.target

takeover /etc/systemd/system/checkupdates.service $D/service/checkupdates.service  sudo
takeover /etc/systemd/system/checkupdates.timer   $D/service/checkupdates.timer    sudo
takeover /etc/systemd/system/mirrorlist.service   $D/service/mirrorlist.service    sudo 
takeover /etc/systemd/system/mirrorlist.timer     $D/service/mirrorlist.timer      sudo

systemctl --user daemon-reload

AAA=/usr/var/local/spotifyd/cache
if [ ! -d "$AAA" ];then
    sudo mkdir -p $AAA
    sudo chmod 777 $AAA
fi


mkdir -p $VAR/
echo "PATH=$PATH" > $VAR/path.env
takeover ~/.config/environment.d/path.conf $VAR/path.env

rc ~/.profile
rc ~/.bashrc

git submodule init
git submodule update

bash extern/external.sh

setconf "commit" "`git rev-parse --verify HEAD`"
chmod -w $VAR/setup

echo 
make
