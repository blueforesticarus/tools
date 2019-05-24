D=`dirname "$(readlink -f "$0")"`
chmod +x $D/bin/*
ln -s $D/bin ~
ln -s $D/Makefile ~
