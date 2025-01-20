# Required provider configuration
terraform {
  required_providers {
    proxmox = {
      #source  = "TheGameProfi/proxmox"
      #source = "telmate/proxmox"
      source = "bpg/proxmox"
      version = "0.70.0"
      #version = "0.69.1"
    }
  }
}

# Proxmox provider configuration
provider "proxmox" {
  endpoint = var.proxmox_url
  api_token = var.proxmox_token_id
  insecure = true
  ssh {
    agent    = true
    username = var.proxmox_username
    password = var.proxmox_password
  }
}