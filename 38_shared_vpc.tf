resource "google_compute_shared_vpc_host_project" "host" {
  project = module.project-networking.project_id
}

resource "google_compute_shared_vpc_service_project" "app-project" {
  host_project    = module.project-networking.project_id
  service_project = "nginx-hello-dev-19252"
}