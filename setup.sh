D=`dirname "$(readlink -f "$0")"`
echo "$D"
PATH=$PATH:$D/bin

chmod +x $D/bin/*

read -p "Create symlink to tools/bin? (Y/n): " YN
case ${YN:0:1} in
    n|N )
        SYM=$D/bin
    ;;
    * )
        read -e -p "Symlink location: " -i "~/.tools" SYM 
        SYM=${SYM/#\~/$HOME}
        ln -s -Tf "$D/bin" $SYM
    ;;
esac

read -p "Create symlink to Makefile to home dir? (Y/n): " YN
case ${YN:0:1} in
    n|N )
            
    ;;
    * )
        ln -s $D/Makefile ~
    ;;
esac


echo "You need to add this line to your .bashrc:"
echo "PATH=\$PATH:$SYM"

read -p "Add automatically? (Y/n):  " YN
case ${YN:0:1} in
    n|N )
        
    ;;
    * )
        S="PATH=\$PATH:$SYM"
        grep "$S" ~/.bashrc || echo "$S" >> ~/.bashrc
    ;;
esac
sudo $D/bin/i root $D

./external.sh
