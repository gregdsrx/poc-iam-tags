provider "google" {
  alias      = "project-data"
  project    = var.project-id-data
  credentials = file("key.json")
}

provider "google" {
  alias      = "project-consumer"
  project    = var.project-id-consumer
  credentials = file("key.json")
}