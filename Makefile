MAKE=make -f $(shell i root)/Makefile #

LATEST ?= $(shell cat .iplatest)#

ip ?=	$(shell echo $(LATEST) | cut -d @ -f2)#
user ?= $(shell echo $(LATEST) | cut -d @ -f1)#
A = $(user)@$(ip)#

MNT ?= ~/mnt/$(RHOSTNAME)#
RF?=/home/$(user)#

TEXT = $(A) $(RHOSTNAME)#
RHOSTNAME = $(eval RHOSTNAME := $(shell ssh -o StrictHostKeyChecking=no $(A) "hostname" 2> .blah))$(OUTPUT)

mount mnt fs: update
	@mkdir -p $(MNT)
	sshfs $(A):$(RF) $(MNT) -o allow_other  || rmdir $(MNT)

mount.root mnt.root fs.root: update
	@mkdir -p $(MNT).root
	sshfs $(A):/ $(MNT).root -o allow_other  || rmdir $(MNT).root

HOSTNAME?=$(shell hostname)#
RMNT=~/mnt/$(HOSTNAME)#
RRF=/home/$(USER)#
RIP=`cut -d \  -f1 <<< $$SSH_CLIENT`#
mounted rmount rfs rmnt: update
	@ssh -t -o StrictHostKeyChecking=no $(A) 'set -x; mkdir -p $(RMNT) && nohup sshfs $(USER)@$(RIP):$(RRF) $(RMNT) -o allow_other && ln -sf -T $(RMNT) dev || rmdir $(RMNT)'	

clean_mounted clean_rmount clean_rfs clean_rmnt:
	@ssh -o StrictHostKeyChecking=no $(A) 'set -x; fusermount -zu $(RMNT); rmdir $(RMNT)'
	
	
ssh: update
	@ssh -t -Y -o StrictHostKeyChecking=no $(A)

sshkey: update
	@ssh-copy-id $(A) 

rsshkey: update 
	@ssh -t -o StrictHostKeyChecking=no $(A) 'ssh-copy-id $(USER)@$(RIP)' 

sshfix:    
	@test `grep -F "$(ip)" ~/.ssh/known_hosts | wc -l` != "0" || echo "WARN: $(ip) not in ~/.ssh/known_hosts"	
	@test `grep -F "$(ip)" ~/.ssh/known_hosts | wc -l` == "1" || echno "ERR: $(ip) has multible entries in ~/.ssh/known_hosts"
	@grep -v "$(ip)" ~/.ssh/known_hosts | tee ~/.ssh/known_hosts

sshterminfo: update
	infocmp $$TERM | ssh $(A) "mkdir -p .terminfo && cat >/tmp/ti && tic /tmp/ti"

select: _select update
_select: 
	$(eval LATEST := $(firstword $(shell choosefrom .iplist)))

add:
	@touch .iplist;\
	touch .iplatest;\
	read -p "Enter User (default: $(user)): " line;\
	user=$${line:-$(user)};\
	read -p "Enter IP: " -i "10.30.1." -e line;\
	IP=$${line?Error: must supply an IP};\
	A=$$user@$$IP;\
	echo $$A > .iplatest;\
	cat .iplatest

update: 
	@#todo only expand text if you need too
	@test "$(A)" != "@" || echno "No address selected"
	@cp .iplist .iplist_
	@grep -qF "$(A)" .iplist || echo $(TEXT) >> .iplist_
	@cat .iplist_ | sed 's/^.*$(A).*$$/$(TEXT)/' > .iplist__
	@mv .iplist__ .iplist && rm .iplist_
	@echo $(A) > .iplatest
	
	@! ([ -z "$(RHOSTNAME)" ] && timeout .3 ping -c 1 $(ip) &> /dev/null && echo "[DOWN] $(A) :no ssh" )
	@! ([ -z "$(RHOSTNAME)" ] && echo "[DOWN] $(A) :cannot ping")
	@echo "[UP]   $(A) => host: $(RHOSTNAME)"

unmount: update
	@fusermount -zu $(MNT)
	@rmdir $(MNT)

unmountall:
	@-for i in ~/mnt/*; do fusermount -zu "$$i"; done
	@-rmdir ~/mnt/*

cleanfs:
	@-rmdir ~/mnt/*

doall:
	@mv .iplatest .iplatest.save
	@cat .iplist | cut -d \  -f1 | sed -e 's/^/LATEST=/' | xargs -I 'VAR' env VAR $(MAKE) --no-print-directory $(COMMAND) ||: 
	@mv .iplatest.save .iplatest

avail:
	@COMMAND=update $(MAKE) doall --no-print-directory 2>/dev/null | tee .avail
	@cat .avail | grep "^\[UP\]" | cut -d " " -f 4,7 > .iplist.avail 

iplist:
	@echo "Grabbing .iplist from $(A)"	
	@scp $(A):.iplist ~/.iplist_ || echno "    $(A) has no .iplist"
	@cat ~/.iplist >> ~/.iplist_
	@cat .iplist_ | sort | rev | uniq -f 1 | rev > .iplist__
	@mv .iplist__ .iplist && rm .iplist_

iplistall:
	COMMAND=iplist $(MAKE) avail --no-print-directory 2>/dev/null
	

.PHONY:mount mnt fs mount.root mnt.root fs.root mounted rmount rmnt rfs clean_mounted clean_rmount clean_rmnt clean_rfs ssh sshkey sshfix sshterminfo select _select add update unmount unmountall cleanfs rsshkey

