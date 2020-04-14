#Acquire external tools

cd `i root`/extern
rm -rf bin
mkdir -p bin


cd DaveScripts && find * -type f -name "*.sh" -exec ln -snf ../DaveScripts/{} ../bin/dave_{} \;

cd ../bin
wget https://waf.io/waf-2.0.17 -O waf
ln -sfn ../rofi_android_theme/android android
chmod +x * 

cd ../rofi_android_theme
mkdir -p ~/.local/share/fonts
cp feather.ttf ~/.local/share/fonts/
fc-cache

cd ~/.config/rofi
ln -sfn "`i root`/extern/rofi_android_theme/" android

#cd `i root`/config/qute
#ln -snf ../../extern/qutewal/qutewal.py
#ln -snf ../../extern/qutewal/iqutefy.py

