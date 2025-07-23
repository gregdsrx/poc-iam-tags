### Création de projet avec tag obligatoire (possible si accès organisation) ###
#resource "google_project" "my_project" {
#  name       = "My Project"
#  project_id = "your-project-id"
#  org_id     = "1234567"
#  tags = {"1234567/env":"dev"}
# }

resource "google_tags_tag_binding" "binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${var.project_number}"
  tag_value = var.tag_value_id
}
