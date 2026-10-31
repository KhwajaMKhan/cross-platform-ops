variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name_prefix" {
  type    = string
  default = "cross-platform-ops-lab"
}

variable "linux_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "windows_instance_type" {
  type    = string
  default = "t3.small"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Your IP/32 for optional SSH/RDP; leave empty for SSM-only"
  default     = ""
}
