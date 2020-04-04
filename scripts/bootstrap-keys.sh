#!/usr/bin/env sh

set -e

CERT_FILE=./keys/id_terraform

if [ -f "$CERT_FILE" ]; then
  echo "$CERT_FILE already exists. To avoid loosing data, I will not generate a new SSH key."
else
  echo "Generating a new SSH Key at $CERT_FILE"
  ssh-keygen -t rsa -C "terraform@apricote.de" -m PEM -f $CERT_FILE
  chmod 600 keys/id_terraform*
fi