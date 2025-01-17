resource "proxmox_virtual_environment_vm" "agent_vms" {
  # Set variables to be used during node creating
  count       = "${var.count_agent_vms}"
  name        = "${var.hostnames_agent[count.index]}"
  description = "Managed by OpenTofu"
  tags        = var.vm_agent_tags
  node_name   = "${var.target_nodes[count.index]}"

  # QEMU agent config
  agent {
    # Qemu guest agent is enabled since it's installed in the cloud-init image. Set to false if not.
    enabled = true
  }

  stop_on_destroy = true
  clone {
    node_name = "${var.target_nodes[0]}"
    vm_id     = "8001"
  }
  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  vga {
    memory    = 16
    type      = "serial0"
  }

  disk {
    datastore_id = "${var.proxmox_storage}"
    interface    = "scsi0"
    size         = "${var.agent_disk_size}"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.vm_agent_ips[count.index]}"
        gateway = "${var.vm_gateway_ip}"
      }
    }

    dns {
      domain  = "${var.fqdn}"
      servers = "${var.vm_dns_ips}"
    }
    
    user_data_file_id = proxmox_virtual_environment_file.cloudinit_user[count.index].id
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = "${var.vm_vlan}"
  }

  # Upload K3S install script
  provisioner "file" {
    source      = "k3s-install.sh"
    destination = "/tmp/k3s-install.sh"

    connection {
      type     = "ssh"
      user     = var.user
      private_key = file("~/.ssh/id_rsa")
      host     = trim(var.vm_agent_ips[count.index], "/24")
    }
  }

  # Execute K3S Script
  provisioner "remote-exec" {
    inline = ["bash /tmp/k3s-install.sh ${count.index} agent ${var.k3s_token}"]

    connection {
      type     = "ssh"
      user     = var.user
      private_key = file("~/.ssh/id_rsa")
      host     = trim(var.vm_agent_ips[count.index], "/24")
    }
  }
}