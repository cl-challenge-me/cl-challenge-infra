locals {
  services = [
    "compute.googleapis.com"
  ]
}

module "project-networking" {
  source = "git@github.com:pavelrn/cl-challenge-base-project.git?ref=v1.6"
  name            = "networking-${var.env}"
  folder_id       = var.folder_id
  services        = local.services
  billing_account = var.billing_account
  regions         = var.regions
  ip_cidr_ranges = [
    cidrsubnet(var.vm_ip_cidr_range, 4, 0),
    cidrsubnet(var.vm_ip_cidr_range, 4, 1)
  ]
}