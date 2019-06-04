
LATEST = $(shell cat .iplatest)

ip ?=   $(shell echo $(LATEST) | cut -d @ -f2)
user ?= $(shell echo $(LATEST) | cut -d @ -f1)
A = $(user)@$(ip)

MNT ?= ~/mnt/$(HOSTNAME)
RF?=/home/$(user)

TEXT = $(A) $(HOSTNAME)
HOSTNAME = $(eval HOSTNAME := $(shell ssh $(A) "hostname" 2> .blah))$(OUTPUT)

fs: update
	@mkdir -p $(MNT)
	sshfs $(A):$(RF) $(MNT) || rmdir $(MNT)

ssh: update
	@ssh -t -Y -o StrictHostKeyChecking=no $(A)

sshkey: update
	@ssh-copy-id $(A) 

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
	@grep -qF "$(A)" .iplist || echo $(TEXT) >> .iplist
	@cat .iplist | sed 's/^.*$(A).*$$/$(TEXT)/' > .iplist_
	@mv .iplist_ .iplist
	@echo $(A) > .iplatest

unmount: update
	@fusermount -zu $(MNT)
	@rmdir $(MNT)

unmountall: update
	@-for i in ~/mnt/*; do fusermount -zu "$$i"; done
	@-rmdir ~/mnt/*

cleanfs:
	@-rmdir ~/mnt/*

