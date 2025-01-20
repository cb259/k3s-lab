# Proxmox provider API variables
variable "proxmox_url" {
  description = "Proxmox provider API URL"
  type        = string
  sensitive   = true
}

variable "proxmox_secret" {
  description = "Proxmox provider API secret"
  type        = string
  sensitive   = true
}

variable "proxmox_token_id" {
  description = "Proxmox provider API token ID. This is a combination of the token and secret."
  type        = string
  sensitive   = true
}

# Proxmox SSH provider variables
variable "proxmox_username" {
  description = "Proxmox SSH connection username"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox SSH connection password"
  type        = string
  sensitive   = true
}

variable "proxmox_host" {
  description = "Proxmox SSH connection host"
  type        = string
  sensitive   = true
}

# K3S master variables
variable "master_disk_size" {
  description = "VM master disk size in GB"
  type        = string
  default     = "8"
}

variable "count_master_vms" {
  description = "Number of k3s sever VMs to create"
  type        = string
}

variable "hostnames_master" {
  description = "VM hostnames used to set hostnames for k3s masters"
  type        = list
  default     = [""]
}

variable "vm_master_tags" {
  description = "Tags to be applied to the VMs within Proxmox"
  type        = list
  default     = [""]
}

variable "vm_master_ips" {
  description = "IP addresses used for the master VMs"
  type        = list
  default     = [""]
}

# K3S agent variables
variable "agent_disk_size" {
  description = "VM agent disk size in GB"
  type        = string
  default     = "8"
}

variable "count_agent_vms" {
  description = "Number of k3s agent VMs to create"
  type        = string
}

variable "hostnames_agent" {
  description = "VM hostnames used to set hostnames for k3s agents"
  type        = list
  default     = [""]
}

variable "vm_agent_tags" {
  description = "Tags to be applied to the VMs within Proxmox"
  type        = list
  default     = [""]
}

variable "vm_agent_ips" {
  description = "IP addresses used for the agent VMs"
  type        = list
  default     = [""]
}

# Common variables (Across all VMs)
variable "hostname" {
  description = "VM name"
  type        = string
  default     = ""
}

variable "target_nodes" {
  description = "Proxmox node names on which VMs can be built"
  type        = list
  default     = [""]
}

variable "proxmox_storage" {
  description = "Proxmox storage target name"
  type        = string
  sensitive   = false
}

variable "vm_gateway_ip" {
  description = "IP address of the default gateway for all VMs"
  type        = string
}

variable "vm_dns_ips" {
  description = "IP addresses of the DNS servers used for all VMs"
  type        = list
  default     = [""]
}

variable "vm_vlan" {
  description = "VLAN ID used by all VMs"
  type        = string
}

variable "clone_id" {
  description = "The VM ID of the VM template to be cloned"
  type        = string
}

# Cloud-Init template variables
variable "fqdn" {
  description = "VM domain"
  type        = string
  default     = ""
}

variable "user" {
  description = "User name for the user that will be created on the VM"
  type        = string
  default     = ""
}

variable "user_ssh_key" {
  description = "User SSH public key for authentication"
  type        = list
  default     = [""]
}

variable "user_password" {
  description = "Password for the user that will be created"
  type        = string
  default     = ""
  sensitive   = true
}

variable "packages" {
  description = "A list of packages to be installed "
  type        = list
  default     = []
}

# K3S Variables
variable "k3s_token" {
  description = "Token used for the K3S cluster"
  type        = string
  default     = ""
  sensitive   = true
}