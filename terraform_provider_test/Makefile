TF=terraform
TFFLAGS=-var-file=credentials.tfvars

apply: init
	$(TF) apply $(TFFLAGS) 

plan: init
	$(TF) plan $(TFFLAGS)

destroy: init
	$(TF) destroy $(TFFLAGS)

init:
	$(TF) init
