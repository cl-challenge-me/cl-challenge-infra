output "project_id" {
  value = module.project-networking.project_id
}

output "network_id" {
  value = module.project-networking.network_id
}

output "fe_ip_address" {
  value = google_compute_global_address.lb-fe-ip.address
}

output "convenience_message" {
  value = "The application should be available here:\n\n  https://${module.cloud-ep-dns.endpoint}\n"
  description = "Convenience message"
}