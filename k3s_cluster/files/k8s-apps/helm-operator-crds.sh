#!/bin/bash
MANIFEST_FILE=https://raw.githubusercontent.com/fluxcd/helm-operator/${version}/deploy/crds.yaml
K3S_MANIFEST_FOLDER=${k3s_manifest_folder}

curl -sfL $MANIFEST_FILE > $K3S_MANIFEST_FOLDER/helm-operator-crds.yml
