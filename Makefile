TF=terraform
TFFLAGS=""
VALIDATE=terraform validate

apply: init
	$(TF) apply $(TFFLAGS)

plan: init
	$(TF) plan $(TFFLAGS)

destroy: init
	$(TF) destroy $(TFFLAGS)

lint: init
	$(VALIDATE) .

init: keys/id_terraform
	$(TF) init

upgrade:
	$(TF) init -upgrade

import:
	$(TF) import $(TFFLAGS) $(ADDR) $(ID)

keys/id_terraform:
	echo "No private key found! Generating Terraform SSH Keys."
	./scripts/bootstrap-keys.sh
