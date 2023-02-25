TF=terraform
TFFLAGS=-var-file=credentials.tfvars
VALIDATE=terraform validate

apply: init
	$(TF) apply $(TFFLAGS)

plan: init
	$(TF) plan $(TFFLAGS)

destroy: init
	$(TF) destroy $(TFFLAGS)

lint: init
	$(VALIDATE) k3s_cluster_v2
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

kubeconfig: keys/id_terraform

	scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i keys/id_terraform root@`terraform output cluster_public_ip`:/etc/rancher/k3s/k3s.yaml ./kubeconfig.yaml
	sed -i "s/127.0.0.1/`terraform output cluster_public_ip`/g" ./kubeconfig.yaml
	sed -i "s/default/`terraform output cluster_name`/g" ./kubeconfig.yaml