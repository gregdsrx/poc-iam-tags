resource "google_bigquery_dataset" "dataset" {
  dataset_id                = var.dataset_id
  project                   = var.project_id
  location                  = var.location
  resource_tags = {"wavestone-cto-pocinterproj-a/sensitivity":var.tag_value}
}