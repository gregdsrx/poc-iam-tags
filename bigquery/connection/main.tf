resource "google_bigquery_connection" "connection" {
  connection_id = var.connection_id
  location      = var.location
  project       = var.project_id
  friendly_name = "BigLake connection"
  cloud_resource {}
}

# This grants the previous connection IAM role access to the bucket.
resource "google_project_iam_member" "default" {
  role    = "roles/storage.objectViewer"
  project = var.project_id
  member  = "serviceAccount:${google_bigquery_connection.connection.cloud_resource[0].service_account_id}"
}

# This makes the script wait for seven minutes before proceeding.
# This lets IAM permissions propagate.
resource "time_sleep" "default" {
  create_duration = "1m"

  depends_on = [google_project_iam_member.default]
}