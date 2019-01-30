TF=terraform
TFFLAGS=-var-file=credentials.tfvars
VALIDATE=terraform validate -check-variables=false

apply: init
	$(TF) apply $(TFFLAGS) 

plan: init
	$(TF) plan $(TFFLAGS)

destroy: init
	$(TF) destroy $(TFFLAGS)

lint: init
	$(VALIDATE) modules/docker_node
	$(VALIDATE) modules/floating_ip
	$(VALIDATE) services/bitwarden
	$(VALIDATE) .

init: keys
	$(TF) init

keys: keys/id_terraform
	echo "No private key found! Generating Terraform SSH Keys."
	./bootstrap-keys.sh