output "tag_key_id" {
  description = "L'ID complet de la clé de tag créée"
  value       = google_tags_tag_key.key.name
}
