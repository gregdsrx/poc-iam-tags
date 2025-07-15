resource "google_storage_bucket" "bucket" {
  name          = var.name
  project       = var.project
  location      = var.location
  storage_class = var.storage_class
  force_destroy = true
  uniform_bucket_level_access = true

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type = lifecycle_rule.value.action.type
      }
      condition {
        age = lifecycle_rule.value.condition.age
      }
    }
  }
}
