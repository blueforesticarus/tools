#Acquire external tools
cd extern
mkdir -p bin
cd DaveScripts && find * -type f -name "*.sh" -exec ln -snf ../DaveScripts/{} ../bin/dave_{} \;

cd ../bin
wget https://waf.io/waf-2.0.17 -O waf
chmod +x * 
