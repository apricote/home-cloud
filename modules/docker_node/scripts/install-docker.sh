#!/bin/bash
set -e
# Source: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository

echo "# apt-get update"
apt-get update
echo "# apt-get upgrade -y"
DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade

# Add Repository
echo "# apt-get install"
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "# apt-get update"
apt-get update

# Install Docker
echo "# apt-get install docker-ce"
apt-get install -y docker-ce
