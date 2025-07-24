output "tag_key_id_domaine" {
  value       = module.tag_domain.tag_key_id
  description = "ID de la clé de tag 'domaine'"
}

output "tag_key_name_domaine" {
  value       = module.tag_domain.tag_key_name
  description = "Name de la clé de tag 'domaine'"
}

output "tag_key_namespaced_name_domaine" {
  value       = module.tag_domain.tag_key_namespaced_name
  description = "Namespaced name de la clé de tag 'domaine'"
}

output "tag_key_short_name_domaine" {
  value       = module.tag_domain.tag_key_short_name
}

output "tag_values_ids_domaine" {
  value       = module.tag_domain.tag_values_ids
  description = "Map des tagValues créés pour 'domaine'"
}
output "tag_values_name_domaine" {
  value       = module.tag_domain.tag_values_names
  description = "Name de la clé de tag 'domaine'"
}

output "tag_values_namespaced_name_domaine" {
  value       = module.tag_domain.tag_values_namespaced_names
  description = "Namespaced name de la clé de tag 'domaine'"
}

output "tag_values_short_name_domaine" {
  value       = module.tag_domain.tag_values_short_names
}

