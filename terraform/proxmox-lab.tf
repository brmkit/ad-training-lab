##################### PROVIDER BLOCK #####################
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_api_url   = "https://${var.pve_node_ip}:8006/api2/json"
  pm_api_token_id = var.tokenid
  pm_api_token_secret = var.tokenkey
  pm_tls_insecure = true
  pm_log_enable   = true
}

locals {
  templates = {
    workstaion        = "traininglab-ws",
    server            = "traininglab-win2019",
    ubuntu            = "traininglab-server"
  }
}

##################### RESOURCE BLOCK #####################

resource "proxmox_vm_qemu" "monitoring" {
  name       = "monitoring"
  clone   = local.templates.ubuntu
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "2048"
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "scsi"
    size         = "60G"
    storage      = var.storage_name
  } 

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }
}

resource "proxmox_vm_qemu" "webserver" {
  name       = "webserver"
  clone   = local.templates.ubuntu
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "2048"
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "scsi"
    size         = "60G"
    storage      = var.storage_name
  } 

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }
}

resource "proxmox_vm_qemu" "dc" {
  name       = "DC"
  clone   = local.templates.server
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "4096"  
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "virtio"
    size         = "60G"
    storage      = var.storage_name
  } 

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }

  connection {
    type = "ssh"
    user = var.win_user
    password = var.win_password
    host = self.ssh_host
    target_platform = "windows" 
  }
}

resource "proxmox_vm_qemu" "fs" {
  name       = "FS"
  clone   = local.templates.server
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "4096"  
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "virtio"
    size         = "60G"
    storage      = var.storage_name
  }

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }

  connection {
    type = "ssh"
    user = var.win_user
    password = var.win_password
    host = self.ssh_host
    target_platform = "windows" 
  }
}

resource "proxmox_vm_qemu" "web" {
  name       = "WEB"
  clone   = local.templates.server
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "4096"  
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "virtio"
    size         = "60G"
    storage      = var.storage_name
  }

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }

  connection {
    type = "ssh"
    user = var.win_user
    password = var.win_password
    host = self.ssh_host
    target_platform = "windows" 
  }
}

resource "proxmox_vm_qemu" "ws1" {
  name       = "WS1"
  clone   = local.templates.workstaion
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "4096"  
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "virtio"
    size         = "60G"
    storage      = var.storage_name
  } 

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }

  connection {
    type = "ssh"
    user = var.win_user
    password = var.win_password
    host = self.ssh_host
    target_platform = "windows" 
  }
}

resource "proxmox_vm_qemu" "ws2" {
  name       = "WS2"
  clone   = local.templates.workstaion
  full_clone = false
  agent = 1
  pool = var.pm_pool
  target_node = var.pve_node
  memory     = "4096"  
  cores      = 2
  sockets    = 1
  
  disk {
    type         = "virtio"
    size         = "60G"
    storage      = var.storage_name
  } 

  network {
    model = "virtio"
    bridge = var.netbridge  
  }

  lifecycle {
      ignore_changes = [
        disk,
      ]
  }

  connection {
    type = "ssh"
    user = var.win_user
    password = var.win_password
    host = self.ssh_host
    target_platform = "windows" 
  }
}

##################### OUTPUT BLOCK #####################

output "MONITORING" {
  value = proxmox_vm_qemu.monitoring.ssh_host
  }

output "WEBSERVER" {
  value = proxmox_vm_qemu.webserver.ssh_host
  }

output "DC" {
  value = proxmox_vm_qemu.dc.ssh_host
  }

output "FS" {
  value = proxmox_vm_qemu.fs.ssh_host
  }

output "WEB" {
  value = proxmox_vm_qemu.web.ssh_host
  }

output "WS1" {
  value = proxmox_vm_qemu.ws1.ssh_host
  }
  
output "WS2" {
  value = proxmox_vm_qemu.ws2.ssh_host
  }