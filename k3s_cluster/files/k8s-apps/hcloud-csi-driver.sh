#!/bin/bash
MANIFEST_FILE=https://raw.githubusercontent.com/hetznercloud/csi-driver/${version}/deploy/kubernetes/hcloud-csi.yml
K3S_MANIFEST_FOLDER=${k3s_manifest_folder}


curl -sfL $MANIFEST_FILE > $K3S_MANIFEST_FOLDER/hcloud-csi.yml

cat <<EOF > $K3S_MANIFEST_FOLDER/hcloud-csi-token.yml
apiVersion: v1
kind: Secret
metadata:
  name: hcloud-csi
  namespace: kube-system
stringData:
  token: ${token}
EOF