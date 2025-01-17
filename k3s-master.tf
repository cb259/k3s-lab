# Upload the cloud-init user template to the Proxmox node after replacing the template variables.
resource "proxmox_virtual_environment_file" "cloudinit_user" {
  count        = "${var.count_master_vms}"
  content_type = "snippets"
  datastore_id = "Snippets"
  node_name    = "${var.target_nodes[count.index]}"

  source_raw {
    data = templatefile("./ci-user.yaml", {
      hostname = var.hostnames_master[count.index],
      user     = var.user,
      password = var.user_password,
      ssh_key  = jsonencode(var.user_ssh_key),
      packages = jsonencode(var.packages),
    })

    file_name  = "k3s-ci-user.yaml"
  }
}

# Create the K3S server nodes
resource "proxmox_virtual_environment_vm" "master_vms" {
  # Set variables to be used during node creating
  count       = "${var.count_master_vms}"
  name        = "${var.hostnames_master[count.index]}"
  description = "Managed by OpenTofu"
  tags        = var.vm_master_tags
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
    size         = "${var.master_disk_size}"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.vm_master_ips[count.index]}"
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

  # Upload K3S install script to VM
  provisioner "file" {
    source      = "k3s-install.sh"
    destination = "/tmp/k3s-install.sh"

    connection {
      type     = "ssh"
      user     = var.user
      private_key = file("~/.ssh/id_rsa")
      host     = trim(var.vm_master_ips[count.index], "/24")
    }
  }

  # Execute K3S Script
  provisioner "remote-exec" {
    inline = ["bash /tmp/k3s-install.sh ${count.index} server ${var.k3s_token}"]

    connection {
      type     = "ssh"
      user     = var.user
      private_key = file("~/.ssh/id_rsa")
      host     = trim(var.vm_master_ips[count.index], "/24")
    }
  }
}