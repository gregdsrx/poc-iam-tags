resource "google_project_iam_member" "project" {
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