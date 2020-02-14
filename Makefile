BLAHi:=$(shell chmod +x `i root`/bin/*)

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

