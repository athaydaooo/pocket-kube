#!/bin/bash

# Stop k3s service
systemctl stop k3s

# Uninstall k3s
/usr/local/bin/k3s-uninstall.sh

# Remove k3s data directories
rm -rf /var/lib/rancher/k3s
rm -rf /etc/rancher/k3s
rm -rf /var/lib/kubelet
rm -rf /var/lib/cni
rm -rf /etc/cni
rm -rf /var/run/flannel

# Remove k3s binary
rm -f /usr/local/bin/k3s

echo "K3s has been completely purged from the system"