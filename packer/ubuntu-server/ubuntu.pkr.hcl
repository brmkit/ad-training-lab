packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "traininglab-server" {
  proxmox_url             = "https://${var.proxmox_node}:8006/api2/json"
  node                    = var.proxmox_hostname
  username                = var.proxmox_api_id
  token                   = var.proxmox_api_token
  communicator            = "ssh"
  ssh_username            = var.lab_username
  ssh_password            = var.lab_password
  ssh_timeout             = "30m"
  qemu_agent              = true
  cores                   = 6
  cpu_type                = "host"
  memory                  = 8192
  vm_name                 = "traininglab-server"
  tags                    = "traininglab-server"
  template_description    = "TrainingLab Ubuntu Server Template"
  insecure_skip_tls_verify = true
  task_timeout            = "30m"
  http_directory          = "server"
  scsi_controller         = "virtio-scsi-single"
  boot_wait               = "10s"

  boot_iso {
    type             = "ide"
    iso_url          = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
    unmount          = true
    iso_checksum     = "sha256:e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
    iso_storage_pool = "local"
    iso_download_pve = true
  }

  additional_iso_files {
    cd_files = [
      "./server/meta-data",
      "./server/user-data"
    ]
    cd_label         = "cidata"
    iso_storage_pool = "local"
    unmount          = true
  }

  network_adapters {
    bridge = var.netbridge
  }

  disks {
    disk_size    = "30G"
    storage_pool = var.storage_name
    type         = "scsi"
  }
  
  boot_command = [
    "c", "<wait3s>",
    "linux /casper/vmlinuz --- autoinstall s=/cidata/", "<enter><wait3s>",
    "initrd /casper/initrd", "<enter><wait3s>",
    "boot", "<enter>"
  ]
}

build {
  sources = ["sources.proxmox-iso.traininglab-server"]
}
