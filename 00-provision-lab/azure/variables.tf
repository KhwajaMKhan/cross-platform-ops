variable "location" {
  type    = string
  default = "eastus"
}

variable "name_prefix" {
  type    = string
  default = "crossplatformops"
}

variable "admin_username" {
  type    = string
  default = "labadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "linux_vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "windows_vm_size" {
  type    = string
  default = "Standard_B2s"
}
