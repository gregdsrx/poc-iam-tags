terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.42.0"
    }
  }
}

provider "google" {
  project     = "wavestone-cto-pocinterproj-a"
}