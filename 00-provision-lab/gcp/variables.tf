variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "zone" {
  type    = string
  default = "us-east1-b"
}

variable "name_prefix" {
  type    = string
  default = "cross-platform-ops-lab"
}

variable "linux_machine_type" {
  type    = string
  default = "e2-micro"
}

variable "windows_machine_type" {
  type    = string
  default = "e2-small"
}
