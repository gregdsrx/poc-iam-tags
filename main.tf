terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.42.0"
    }
  }
}

module "tag_env" {
  source = "./tags"

  parent_project     = var.project-id-data
  tag_key_short_name = "env"
  tag_key_description = "Tag clé pour l'environnement"

  tag_values = [
    { short_name = "dev", description = "Development environment" },
    { short_name = "prod", description = "Production environment" },
    { short_name = "test", description = "Test environment" },
  ]

  providers = {
    google = google.project-data
  }
}

module "tag_sensitivity" {
  source = "./tags"

  parent_project     = var.project-id-data
  tag_key_short_name = "sensitivity"
  tag_key_description = "Tag clé pour la confidentalité des données"

  tag_values = [
    { short_name = "high", description = "High sensitivity" },
    { short_name = "low", description = "Low sensitivity" }
  ]
  
  providers = {
    google = google.project-data
  }
}