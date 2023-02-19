variable "region" {
  description = "Region to deploy infrastructure and applications"
  type        = string
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
  default     = "011168-59E2C9-06B012"
  description = "Billing account ID"
  type        = string
}

variable "ip_cidr_range" {
  default = "10.10.10.0/24"
}