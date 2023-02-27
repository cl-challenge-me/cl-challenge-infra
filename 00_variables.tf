variable "regions" {
  description = "Regions where the applications are deployed"
  type        = list(any)
}

variable "env" {
  description = "Short environment name (dev, stage, prod)"
  type        = string
}

variable "folder_id" {
  description = "Parent folder ID"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "vm_ip_cidr_range" {
  description = "Project IP range used for VMs, le /24 (IP range is split across regions)"
  type        = string
}

variable "app_project_id" {
  type = string
}

variable "app_name" {
  type = string
}