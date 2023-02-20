output "project_id" {
  value = module.project-networking.project_id
}

output "network_id" {
  value = module.project-networking.network_id
}

output "fe_ip_address" {
  value = google_compute_address.default.address
}