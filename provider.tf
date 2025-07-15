provider "google" {
  alias       = "project-marketing"
  project     = var.project-id-marketing
  credentials = file("key.json")
}

provider "google" {
  alias       = "project-sales"
  project     = var.project-id-sales
  credentials = file("key.json")
}