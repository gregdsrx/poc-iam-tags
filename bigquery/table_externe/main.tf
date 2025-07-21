resource "google_bigquery_table" "external" {
  table_id   = var.table_id
  dataset_id = var.dataset_id
  project    = var.project_id

  schema = jsonencode(var.schema)

  external_data_configuration {
    source_format = "CSV"
    autodetect    = false
    source_uris   = [var.gcs_source_uri]
    csv_options {
      skip_leading_rows = 1
      quote = "\""
    }
    connection_id = var.connection_name
  }
}
