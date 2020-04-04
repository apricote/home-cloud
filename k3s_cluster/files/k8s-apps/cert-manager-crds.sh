#!/bin/bash
MANIFEST_FILE=https://github.com/jetstack/cert-manager/releases/download/${version}/cert-manager.crds.yaml
K3S_MANIFEST_FOLDER=${k3s_manifest_folder}

curl -sfL $MANIFEST_FILE > $K3S_MANIFEST_FOLDER/cert-manager-crds.yml
