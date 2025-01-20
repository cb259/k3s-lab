#!/bin/bash
###########################################################
# Assumptions
# -----------
# This script assumes you are trying to instantiate a new, multi-node K3S ckuster.
# Seperation between server and agent nodes is assumed.
#
# Requirements
# -------------
# Three variables must be set:
# - OTF_COUNT should be set to the current count index from Open Tofu/Terraform.
# - INSTALL_MODE should be set to either 'server' or 'agent' depending on the role of the target node,
# - K3S_TOKEN should the the token value you will use across all nodes in the cluster.
#
# Usage
# -----
# k3s-install.sh count install_mode token server_ip
# EX: k3s-install.sh 0 server jdhfuefjshc 192.168.1.1
###########################################################

# Setup
exec >/tmp/k3s-install-debug.log 2>&1

# Set local variables to the vaulues passed to the script
OTF_COUNT=$1
INSTALL_MODE=$2
K3S_TOKEN=$3
SERVER_IP=$4
echo "- Variables set"

# Check the install mode to determine node type
if [ $INSTALL_MODE = "server" ]; then
    # If count is 0 then assume cluster init
    echo "- Running in server install mode"
    if [ $OTF_COUNT -eq 0 ]; then
        # Create K3S server & initialize cluser
        echo "- Starting: Cluster initialization install"
        curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN sh -s - server \
            --cluster-init \
            --node-taint CriticalAddonsOnly=true:NoExecute
        
        # Set permissions on k3s.yaml to allow kubectly without sudo
        echo "- CHMOD 644 on k3s.yaml to allow kubectl without sudo"
        sudo chmod 644 /etc/rancher/k3s/k3s.yaml

        # Exit successfully
        exit 0
    else
        # Create K3S server & join existing cluser
        echo "- Starting: Server install (Existing cluser)"
        curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN sh -s - server \
            --server https://$SERVER_IP:6443 \
            --node-taint CriticalAddonsOnly=true:NoExecute
        
        # Set permissions on k3s.yaml to allow kubectly without sudo
        echo "- CHMOD 644 on k3s.yaml to allow kubectl without sudo"
        sudo chmod 644 /etc/rancher/k3s/k3s.yaml

        # Exit successfully
        exit 0
    fi
elif [ $INSTALL_MODE = "agent" ]; then
    # Create K3S agent & join existing cluser
    echo "- Starting: Agent install"
    curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN sh -s - agent \
        --server https://$SERVER_IP:6443
    
    # Exit successfully
    exit 0
else
    echo "Invalid install mode"
    exit 1
fi

# Exit successfully
exit 0