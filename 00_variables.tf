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
  description = "Billing account ID"
  type        = string
}

variable "ip_cidr_range" {
  description = "Main subnet IP CIDR range"
  type        = string
}

variable "proxy_ip_cidr_range" {
  description = "Load balancer proxy-only subnet IP CIDR range"
  type        = string
}

variable "NGINX_HELLO_PRIV_KEY" {
  description = "Nginx-hello application private key"
  sensitive   = true
}

variable "NGINX_HELLO_CERT" {
  description = "Nginx-hello application certificate"
}

variable "nginx_app_svc" {
  description = "Cross-project application service link"
}