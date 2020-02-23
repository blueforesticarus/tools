D=`dirname "$(readlink -f "$0")"`
echo "$D"
PATH=$PATH:$D/bin

chmod +x $D/bin/*
sudo i root "`realpath $D`"

mkdir -p "$D"/data/ip
touch "$D"/data/ip/list #TODO iplist or conn or avail should do this, not setup

if yesno -Y "Symlink to tools/bin"; then
    read -e -p "Symlink location: " -i "~/.tools" SYM 
    SYM=${SYM/#\~/$HOME}
    ln -s -Tf "$D/bin" $SYM
fi

rc () {
    if ! [ -f $1 ]; then
        return 
    fi

    echo "You need to add this line to your $1:"
    S="source $D/conf/shellrc"
    echo "$S"

    if yesno -Y "Add automatically?" ; then
        grep -F "$S" $1 || echo "$S" >> $1
    fi
}

rc ~/.bashrc
rc ~/.zshrc

bash external.sh
