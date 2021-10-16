function require (){
    if ! which $1 ; then
        REQUIRE=1
    fi
}

#todo, missing alot of deps
require xdotool
require rg
require go
require wget

#UNTESTED
if [ ! -z $REQUIRE ]; then
    echo "install deps"
    exit
fi

if [ ! -d /usr/var/local/tools ]; then 
    sudo mkdir -p /usr/var/local/tools
fi
sudo touch /usr/var/local/tools/index

D=`dirname "$(readlink -f "$0")"`
D=`realpath "$D"`
issym () {
    if [ -e "$1" ] && [ "A`realpath $1`" ==  "A`realpath $2`" ]; then
        return 0
    else
        return 1
    fi
}
ishard () {
    if ( ! issym $@ ) && [ "$1" -ef "$2" ]; then
        return 0
    else
        return 1
    fi
}

if ! issym /usr/var/local/tools/root "$D"; then 
    sudo ln -snfT "$D" /usr/var/local/tools/root
fi

source $D/util/shellrc
cd $D

if [ -z "`$D/bin/i var`" ]; then 
    read -p "Path for var dir: " -i "./data" -e LINE
    mkdir -p "$LINE" || exit 1
    sudo $D/bin/i var $LINE
fi
VAR="`$D/bin/i var`"
echo "var: $VAR"

if [ ! -f $VAR/setup ]; then
    touch $VAR/setup
fi
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
    NAME=$2
    if ! [ -f $1 ]; then
        return 
    fi

    TAG="#ADDED BY TOOLS SETUP.SH"
    S="source $D/util/$NAME #ADDED BY TOOLS SETUP.SH"
        
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
    if [ -z "$HARD" ]; then
        prog=issym
    else
        prog=ishard
    fi

    if ! $prog "$1" "$2"; then
        if [ "`config "$2"`" == "0" ]; then
            echo "Skipping disabled: $1 => $2" >&2
            return 0
        fi
        if yesno -N "Take Over $1 ?" ; then
            DIR="`dirname $1`"
            
            if [ ! -d "$DIR" ] && [ -e "$DIR" -o -h "$DIR" ]; then 
                $3 mv "$DIR" "$DIR".old
            fi

            if [ ! -e "$DIR" ]; then 
                $3 mkdir -p "$DIR"
            fi

            if [ -e "$1" ]; then
                $3 mv "$1" "$1".old
            fi

            if [ -L "$1" -a ! -e "$1" ]; then 
                $3 rm "$1" 
            fi

            if [ -z "$HARD" ]; then
                $3 ln -snf "$2" "$1" 
            else
                $3 ln -nf "$2" "$1" 
            fi
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

#==================================================================================================
#                                      TAKEOVER
##T================================================================================================

takeover_vim () {
    takeover $1/autoload      $2/autoload

    takeover $1/extra_colors $3/extra_colors
    mkdir -p $3/extra_colors
    ln -snf $2/extra_colors/*   $3/extra_colors/
    
    takeover $1/plugins       $3/plugins
    mkdir -p $3/plugins
    ln -snf $2/plugins/*        $3/plugins/
    
    takeover $1/pathogen      $2/pathogen
    takeover $1/syntax        $2/syntax
}

HARD=
takeover_vim ~/.config/nvim  $D/config/vim $VAR/vim
takeover ~/.config/nvim/init.vim $D/config/vim/init.vim
takeover ~/.config/nvim/extra.vim $D/config/vim/extra.vim

#config
takeover ~/.config/kitty/kitty.conf   $D/config/kitty.conf
takeover ~/.config/qutebrowser        $D/config/qute
takeover ~/.config/spotifyd/spotifyd.conf $D/config/spotifyd.conf
takeover ~/.local/share/applications  $D/desktop

#autostartx autologin enviroment and shellrc
takeover /etc/profile.d/0_env.sh      $D/config/shell/env.sh sudo
takeover /etc/profile.d/1_path.sh     $D/util/path.env sudo
takeover ~/.xinitrc                 $D/config/display/xinitrc
takeover ~/.i3/config               $D/config/display/i3.conf
takeover ~/.config/rofi/config.rasi $D/config/display/rofi.conf
takeover ~/.config/dunst/dunstrc    $D/config/display/dunstrc
takeover ~/.profile                 $D/config/shell/profile
takeover ~/.config/fish/config.fish $D/config/shell/rc/config.fish || rc ~/.config/fish/fish.config setup.fish
takeover ~/.config/fish/functions/fzf_key_bindings.fish $D/config/shell/key-bindings.fish
takeover ~/.zshrc                   $D/config/shell/rc/zshrc       || rc ~/.zshrc                   shellrc
takeover ~/.bashrc                  $D/config/shell/rc/bashrc      || rc ~/.bashrc                  shellrc

#udev
takeover /etc/udev/rules.d/95-monitor-hotplug.rules $D/udev/95-monitor-hotplug.rules sudo 
takeover /etc/udev/rules.d/99-batify.rules          $D/udev/99-batify.rules          sudo 
takeover /etc/acpi/handler.sh                       $D/config/acpi.sh                sudo 

#systemd (user)
HARD=True
takeover ~/.config/systemd/user/spotifyd.service    $D/service/spotifyd.service
takeover ~/.config/systemd/user/conky.service       $D/service/conky.service
takeover ~/.config/systemd/user/easyeffects.service $D/service/easyeffects.service
takeover ~/.config/systemd/user/compton.service     $D/service/compton.service
takeover ~/.config/systemd/user/dunst.service       $D/service/dunst.service
takeover ~/.config/systemd/user/i3focuslast.service $D/service/i3focuslast.service
takeover ~/.config/systemd/user/i3.service          $D/service/i3.service
takeover ~/.config/systemd/user/xsession.target     $D/service/xsession.target
takeover ~/.config/systemd/user/pushrsync.service   $D/service/pushrsync.service
takeover ~/.config/systemd/user/pushrsync.timer     $D/service/pushrsync.timer
takeover ~/.config/systemd/user/jupyter.service     $D/service/jupyter.service
takeover ~/.config/systemd/user/jupyter.socket      $D/service/jupyter.socket

#systemd (system)
takeover /etc/systemd/system/checkupdates.service $D/service/checkupdates.service  sudo
takeover /etc/systemd/system/checkupdates.timer   $D/service/checkupdates.timer    sudo
takeover /etc/systemd/system/mirrorlist.service   $D/service/mirrorlist.service    sudo 
takeover /etc/systemd/system/mirrorlist.timer     $D/service/mirrorlist.timer      sudo
HARD=

systemctl --user daemon-reload

AAA=/usr/var/local/spotifyd/cache
if [ ! -d "$AAA" ];then
    sudo mkdir -p $AAA
    sudo chmod 777 $AAA
fi

mkdir -p $VAR/
#echo "PATH=$PATH" > $VAR/path.env
#takeover ~/.config/environment.d/path.conf $VAR/path.env

git submodule init
git submodule update
cd $D/config/vim/extra_colors
git submodule init
git submodule update
cd $D

bash extern/external.sh

mkdir -p $VAR/empty
takeover /usr/share/nvim/runtime/colors $VAR/empty sudo
test "$(ls -A $VAR/empty)" && sudo rm -r $D/util/*

setconf "commit" "`git rev-parse --verify HEAD`"
chmod -w $VAR/setup

mkdir -p $VAR/path.d

echo 
dt
