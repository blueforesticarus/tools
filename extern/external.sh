#Acquire external tools
echo "ENTER external.sh..."
D="`i root`/extern"

cd "$D"
rm -rf bin
mkdir -p bin


cd $D/DaveScripts && find * -type f -name "*.sh" -exec ln -snf ../DaveScripts/{} ../bin/dave_{} \;


cd $D/rofi_android_theme
mkdir -p ~/.local/share/fonts
cp feather.ttf ~/.local/share/fonts/
fc-cache

cd $D/i3-focus-last
go build
ln -sfn ../i3-focus-last/i3-focus-last ../bin/i3-focus-last

cd ~/.config/rofi
ln -sfn "`i root`/extern/rofi_android_theme/" android

#modified, so now I just track these
#cd `i root`/config/qute
#ln -snf ../../extern/qutewal/qutewal.py
#ln -snf ../../extern/qutewal/iqutefy.py

cd $D/bin
printf 'WGET ' && wget https://waf.io/waf-2.0.17 -O waf -nv
ln -sfn ../rofi_android_theme/android android
chmod +x * 
