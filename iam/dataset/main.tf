resource "google_bigquery_dataset_iam_member" "dataset" {
  dataset_id = var.dataset_id
  project = var.project_id
  role    = var.role
  member  = var.member

# Optionnel : condition IAM
  dynamic "condition" {
    for_each = var.condition_enabled ? [1] : []
    content {
      title       = var.condition_title
      description = var.condition_description
      expression  = var.condition_expression
    }
  }
}