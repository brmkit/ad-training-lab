packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "traininglab-server" {
  proxmox_url  = "https://${var.proxmox_node}:8006/api2/json"
  node         = "${var.proxmox_hostname}"
  username     = "${var.proxmox_api_id}"
  token        = "${var.proxmox_api_token}"
  iso_file     = "local:iso/ubuntu-server.iso"
  communicator             = "ssh"
  ssh_username             = "${var.lab_username}"
  ssh_password             = "${var.lab_password}"
  ssh_timeout              = "30m"
  qemu_agent               = true
  cores                    = 6
  memory                   = 8192
  vm_name                  = "traininglab-server"
  template_description     = "TrainingLab Ubuntu Server Template"
  insecure_skip_tls_verify = true
  unmount_iso = true
  http_directory           = "server"   # or server files inside the http folder on a container inside proxmox host

  additional_iso_files {
    cd_files = [
      "./server/meta-data",
      "./server/user-data"
      ]
      cd_label = "autoinstall"
      iso_storage_pool = "local"
  }

  network_adapters {
    bridge = var.netbridge
    }

  disks {
    disk_size    = "30G"
    storage_pool = var.storage_name
  }
  boot_wait = "10s"

  boot_command = [
      "<esc><esc><esc><esc>e<wait>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del>",
      "<del><del><del><del><del><del><del><del><del>",
      "linux /casper/vmlinuz --- autoinstall s=/autoinstall/<enter><wait>",
      "initrd /casper/initrd<enter><wait>",
      "boot<enter>",
      "<enter><f10><wait>"
    ]
}

build {
  sources = ["sources.proxmox-iso.traininglab-server"]
}
