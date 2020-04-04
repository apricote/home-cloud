#!/bin/bash

until ( \
  curl -sfL https://get.k3s.io | \
    INSTALL_K3S_VERSION='v${install_k3s_version}' \
    K3S_CLUSTER_SECRET='${k3s_cluster_secret}' \
    INSTALL_K3S_EXEC='%{ if is_k3s_server } ${k3s_tls_san} %{ endif }' \
    %{ if !is_k3s_server } K3S_URL='https://${k3s_url}:6443'%{ endif } \
    sh - \
  ); do
  echo 'k3s did not install correctly'
  sleep 2
done

%{ if is_k3s_server }
until kubectl get pods -A | grep 'Running';
do
  echo 'Waiting for k3s startup'
  sleep 5
done
%{ endif }