terraform {
  backend "gcs" {
    prefix = "cl-challenge-infra"
  }
  required_providers {
    google      = "=4.52.0"
    google-beta = "=4.52.0"
  }
}

provider "google" {

}