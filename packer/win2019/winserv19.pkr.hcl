packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
    windows-update = {
      version = "0.14.3"
      source = "github.com/rgl/windows-update"
    }
  }
}

source "proxmox-iso" "traininglab-win2019" {
  proxmox_url  = "https://${var.proxmox_node}:8006/api2/json"
  node         = var.proxmox_hostname
  username     = var.proxmox_api_id
  token        = var.proxmox_api_token
  iso_file     = "local:iso/win2019_server.iso"
  communicator             = "ssh"
  ssh_username             = var.lab_username
  ssh_password             = var.lab_password
  ssh_timeout              = "30m"
  qemu_agent               = true
  cores                    = 6
  memory                   = 8192
  vm_name                  = "traininglab-win2019"
  tags                     = "traininglab-win2019"
  template_description     = "TrainingLab WindowsServer Template - Sysprep done"
  insecure_skip_tls_verify = true
  unmount_iso = true

  additional_iso_files {
    cd_files =["autounattend.xml"]
    cd_label = "auto-win2019.iso"
    iso_storage_pool = "local"
    unmount      = true
  }

  additional_iso_files {
    device       = "sata0"
    iso_file     = "local:iso/virtio-win.iso"
    unmount      = true
  }


  network_adapters {
    bridge = var.netbridge
  }

  disks {
    type              = "virtio"
    disk_size         = "50G"
    storage_pool = var.storage_name
  }
  scsi_controller = "virtio-scsi-pci"
}


build {
  sources = ["sources.proxmox-iso.traininglab-win2019"]
  
  provisioner "windows-update" {
    search_criteria = "BrowseOnly=0 and IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 25
  }

  provisioner "file" {
    source      = "server-sysprep.xml"
    destination = "C:/Users/Public/sysprep.xml"
  }

  provisioner "windows-shell" {
    inline = [
    "c:\\windows\\system32\\sysprep\\sysprep.exe /mode:vm /generalize /oobe /shutdown /unattend:C:\\Users\\Public\\sysprep.xml",
    ]
  }
}
