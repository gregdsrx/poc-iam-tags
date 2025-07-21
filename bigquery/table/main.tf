resource "google_bigquery_table" "table" {
  table_id   = var.table_id
  dataset_id = var.dataset_id
  project    = var.project_id

  schema = jsonencode(var.schema)
  
  deletion_protection = false
}
