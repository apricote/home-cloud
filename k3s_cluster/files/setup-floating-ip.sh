#!/bin/bash
%{ if use_netdata }
cat >> /etc/netplan/60-floating.cfg <<- EOM
network:
  version: 2
  ethernets:
    eth0:
      addresses:
      - ${floating_ip}/32
EOM
netplan apply
%{ else }
cat >> /etc/network/interfaces.d/99-floating.cfg <<- EOM
auto eth0:1
iface eth0:1 inet static
    address ${floating_ip}
    netmask 255.255.255.255
EOM
ifdown eth0:1 ; ifup eth0:1
%{ endif }
