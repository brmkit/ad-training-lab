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
  node         = var.proxmox_hostname
  username     = var.proxmox_api_id
  token        = var.proxmox_api_token

  #iso_file     = "local:iso/ubuntu_server.iso"    -- uncomment if you want to use local iso file and comment the next four lines
  iso_checksum             = "sha256:45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
  iso_url                  = "https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"
  iso_storage_pool         = "local"
  iso_download_pve = true

  communicator             = "ssh"
  ssh_username             = var.lab_username
  ssh_password             = var.lab_password
  ssh_timeout              = "30m"
  qemu_agent               = true
  cores                    = 6
  cpu_type                  = "host"
  memory                   = 8192
  vm_name                  = "traininglab-server"
  tags                     = "traininglab-server"
  template_description     = "TrainingLab Ubuntu Server Template"
  insecure_skip_tls_verify = true
  unmount_iso = true
  task_timeout = "30m"
  http_directory           = "server"   # or server files inside the http folder on a container inside proxmox host

  additional_iso_files {
    cd_files = [
      "./server/meta-data",
      "./server/user-data"
      ]
      cd_label = "cidata"
      iso_storage_pool = "local"
      unmount = true
  }

  network_adapters {
    bridge = var.netbridge
    }

  scsi_controller = "virtio-scsi-single"

  disks {
    disk_size    = "30G"
    storage_pool = var.storage_name
    type         = "scsi"
    discard      = true
    io_thread     = true
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
      "linux /casper/vmlinuz --- autoinstall s=/cidata/<enter><wait>",
      "initrd /casper/initrd<enter><wait>",
      "boot<enter>",
      "<enter><f10><wait>"
    ]
}

build {
  sources = ["sources.proxmox-iso.traininglab-server"]
}
