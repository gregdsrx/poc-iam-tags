### Outputs pour les clés de tags ###

output "tag_key_name" {
  description = "L'ID numerique de la clé de tag créée"
  value       = google_tags_tag_key.key.name
}

output "tag_key_id" {
  description = "L'ID complet de la clé de tag créée sous la forme tagKeys/{name}"
  value       = google_tags_tag_key.key.id
}

output "tag_key_short_name" {
  description = "Short_name (nom donné à la clé) de la clé de tag créée"
  value       = google_tags_tag_key.key.short_name
}

output "tag_key_namespaced_name" {
  description = "Namespaced_name de la clé de tag créée sous la forme parent/short_name"
  value       = google_tags_tag_key.key.namespaced_name
}

### Outputs pour les valeurs de tags ###

output "tag_values_names" {
  description = "Map des tagValues créés avec leurs ids numériques"
  value = {
    for key, val in google_tags_tag_value.values :
    key => val.name
  }
}

output "tag_values_ids" {
  description = "Map des tagValues créés avec leurs ids (tagValues/{name})"
  value = {
    for key, val in google_tags_tag_value.values :
    key => val.id
  }
}

output "tag_values_short_names" {
  description = "Map des tagValues créées avec leurs short_names (nom donné à la valeur de tag)"
  value = {
    for key, val in google_tags_tag_value.values :
    key => val.short_name
  }
}

output "tag_values_namespaced_names" {
  description = "Map des tagValues créées avec leurs namespaced_names (parent/short_name(clé de tag)/short_name(valeur de tag))"
  value = {
    for key, val in google_tags_tag_value.values :
    key => val.namespaced_name
  }
}