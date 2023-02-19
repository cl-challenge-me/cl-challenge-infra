resource "google_folder" "infra" {
  display_name = "infra"
  parent       = var.folder_id
}

resource "google_folder" "apps" {
  display_name = "apps"
  parent       = var.folder_id
}


