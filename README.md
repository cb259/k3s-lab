# K3S Environment with OpenTofu
This repository contains the code needed to instantiate a K3S Kubernetes environment using virtua machienes on Proxmox using OpenTofu.

## Assumptions
- There is an working Proxmox environment.
- The Proxmox environment contains three nodes where the VMs will be distributed. This can be increased or decreased to match environments of different sizes.
- There is a pre-existing cloud-init VM template that the VMs will be cloned from.
- The cloud-init template alread has the Qemu guest agent installed.
- SSH password auth is used to connect to the Proxmox environment.
- SSH private key auth is used to connect to the VMs.
    - This assumes that the private key to be used is the one of the user running OpenTofu and is present on the machiene where OpenTofu is run.
    - Password can be used in place of SSH key authentication if desired.

## Requirements
- A working OpenTofu environment (Tested on v1.8.8)
    - Terraform should work as well (Not tested).
- The bpg/proxmox provider (v0.69.1 used)

## Usage
1. Copy the repo to your machiene with OpenTofu.
2. Create a terraform.tfvars file and set value for all of the variables declared in variables.tf.
3. Check that you have everything you need ith ```tofu plan```.
4. Once you are ready to execute use ```tofu apply```.