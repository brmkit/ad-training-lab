variable "lab_username" {
  type =  string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "proxmox_hostname" {
  type    = string
  default = ""
}

variable "lab_password" {
  type =  string
  default = ""
  sensitive = true
}

variable "proxmox_api_id" {
  type = string
  default = ""
}

variable "proxmox_api_token" {
  type = string
  default = ""
}

variable "storage_name" {
  type = string
  default = "local-lvm"
}

variable "netbridge" {
  type = string
  default = "vmbr1"
}
