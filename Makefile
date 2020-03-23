BLAHi:=$(shell chmod +x `i root`/bin/* >/dev/null 2>&1)

default:
	@echo -e "Erich Spaker' Dev Tools. ¡Muy Bueno! Edition\nRevised $$(lsdate $$(i root)/bin $$(i root)/Makefile | head -1 | cut -d '=' -f1 )"

avail:
	@avail

select:
	@iplist --pretty --select
	@avail --status	

list:
	@echo "LIST:"
	@iplist --user | column
	@echo	
	@echo "AVAIL:"
	@iplist --avail --pretty

add:
	@ipaddtool

ssh:
	@conn --ssh
	
fs rfs ffs xfs xffs xrfs keys rkey fkey:
	@conn --$@

sshkey:
	@conn --copyid

path PATH:
	@echo "$$USER:"
	@echo $$PATH | grep --color -F -e "`i root`/bin" -e ''
	@echo -e "\nroot:"
	@sudo bash -c 'echo $$PATH' | grep --color -F -e "`i root`/bin" -e ''

serial:
	screen /dev/ttyUSB0 115200

IP=192.168.6.
DEV=usb0
bbnet:
	sudo ip link set up $(DEV)
	sudo ip addr add $(IP)1 dev $(DEV)
	sudo ip route add $(IP)0/24 dev $(DEV) via $(IP)1

chmod:
	sudo chmod +x `i root`/bin/*
