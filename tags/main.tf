resource "google_tags_tag_key" "key" {
  parent      = "projects/${var.parent_project}"
  short_name  = var.tag_key_short_name
  description = var.tag_key_description
}

resource "google_tags_tag_value" "values" {
  for_each    = { for v in var.tag_values : v.short_name => v }
  parent      = google_tags_tag_key.key.id
  short_name  = each.value.short_name
  description = each.value.description
}