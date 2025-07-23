# Configuration du provider Google avec une version précise
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.42.0"
    }
  }
}

# Récupération des informations du projet "marketing"
data "google_project" "marketing" {
  provider   = google.project-marketing
  project_id = var.project-id-marketing
}

# Récupération des informations du projet "sales"
data "google_project" "sales" {
  provider   = google.project-sales
  project_id = var.project-id-sales
}

             ############   TAGS   ############

# Création de la clé de tag "domaine" avec plusieurs valeurs (marketing, sales, rh)
module "tag_domain" {
  source = "./tags"
  parent_project      = var.project-id-marketing
  tag_key_short_name  = "domain"
  tag_key_description = "Tag clé pour les domaines métiers"
  tag_values = [
    { short_name = "marketing", description = "Domaine marketing" },
    { short_name = "sales", description = "Domaine sales" },
    { short_name = "rh", description = "Domaine ressources humaines" },
  ]
}

# Création de la clé de tag "env" avec les valeurs dev, prod, test
module "tag_env" {
  source = "./tags"
  parent_project      = var.project-id-marketing
  tag_key_short_name  = "env"
  tag_key_description = "Tag clé pour l'environnement"
  tag_values = [
    { short_name = "dev", description = "Development environment" },
    { short_name = "prod", description = "Production environment" },
    { short_name = "test", description = "Test environment" },
  ]
}

# Création de la clé de tag "sensitivity" pour la confidentialité des données
module "tag_sensitivity" {
  source = "./tags"
  parent_project      = var.project-id-marketing
  tag_key_short_name  = "sensitivity"
  tag_key_description = "Tag clé pour la confidentalité des données"
  tag_values = [
    { short_name = "high", description = "High sensitivity" },
    { short_name = "medium", description = "Medium sensitivity" },
    { short_name = "low", description = "Low sensitivity" }
  ]
}

# Association d'un tag "domaine=marketing" au projet marketing
module "tag_binding_project_marketing" {
  source = "./project"
  project_number = data.google_project.marketing.number
  tag_value_id   = module.tag_domain.tag_values_ids["marketing"]
}

# Association d'un tag "domain=sales" au projet sales
module "tag_binding_project_sales" {
  source = "./project"
  project_number = data.google_project.sales.number
  tag_value_id   = module.tag_domain.tag_values_ids["sales"]
}


             ############   RESSOURCES GCS  ############

# Création du bucket GCS "raw-data-marketing-poc" avec une règle de suppression après 30 jours
module "bucket_raw_data_marketing" {
  source = "./storage"
  project       = var.project-id-marketing
  name          = "raw-data-marketing-poc"
  location      = "EU"
  storage_class = "STANDARD"
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 30
      }
    }
  ]
}

# Création du bucket GCS "raw-data-sales-poc" avec une règle de suppression après 30 jours
module "bucket_raw_data_sales" {
  source = "./storage"
  project       = var.project-id-sales
  name          = "raw-data-sales-poc"
  location      = "EU"
  storage_class = "STANDARD"
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 30
      }
    }
  ]
}


             ############   RESSOURCES BIGQUERY  ############

# Création du dataset BigQuery "marketing_dataset" dans le projet marketing
module "bigquery_dataset_marketing" {
  source = "./bigquery/dataset"
  project_id = var.project-id-marketing
  dataset_id = "marketing_dataset"
  location   = "EU"
  tag_value = "low"
}

# Création du dataset BigQuery "sales_dataset" dans le projet sales
module "bigquery_dataset_sales" {
  source = "./bigquery/dataset"
  project_id = var.project-id-sales
  dataset_id = "sales_dataset"
  location   = "EU"
  tag_value = "low"
}

# Création du dataset BigQuery "sensitive_information" dans le projet marketing
module "bigquery_dataset_sensitive_information" {
  source = "./bigquery/dataset"
  project_id = var.project-id-marketing
  dataset_id = "sensitive_information"
  location   = "EU"
  tag_value = "high"
}

# Création d'une connexion BigLake dans le projet marketing pour accéder à GCS
module "bigquery_connection_marketing" {
  source = "./bigquery/connection"
  project_id    = var.project-id-marketing
  connection_id = "marketing_biglake_connection"
  location      = "EU"
}

# Création d'une connexion BigLake dans le projet sales pour accéder à GCS
module "bigquery_connection_sales" {
  source = "./bigquery/connection"
  project_id    = var.project-id-sales
  connection_id = "sales_biglake_connection"
  location      = "EU"
}

# Création d'une table externe BigQuery dans le dataset marketing, basée sur le contenu GCS
module "bigquery_table_marketing" {
  source = "./bigquery/table_externe"
  project_id       = var.project-id-marketing
  dataset_id       = module.bigquery_dataset_marketing.dataset_id
  table_id         = "marketing_raw_table"
  gcs_source_uri   = "gs://${module.bucket_raw_data_marketing.bucket_name}/*"
  connection_name  = module.bigquery_connection_marketing.connection_id
  schema = [
    { name = "user_id",   type = "STRING", mode = "REQUIRED" },
    { name = "email",     type = "STRING", mode = "NULLABLE" },
    { name = "source",    type = "STRING", mode = "NULLABLE" },
    { name = "campaign",  type = "STRING", mode = "NULLABLE" },
    { name = "timestamp", type = "TIMESTAMP", mode = "REQUIRED" }
  ]
}

# Création d'une table externe BigQuery dans le dataset sales, basée sur le contenu GCS
module "bigquery_table_sales" {
  source = "./bigquery/table_externe"
  project_id       = var.project-id-sales
  dataset_id       = module.bigquery_dataset_sales.dataset_id
  table_id         = "sales_raw_table"
  gcs_source_uri   = "gs://${module.bucket_raw_data_sales.bucket_name}/*"
  connection_name  = module.bigquery_connection_sales.connection_id
  schema = [
    { name = "user_id",   type = "STRING",    mode = "REQUIRED" },
    { name = "campaign",  type = "STRING",    mode = "NULLABLE" },
    { name = "product",   type = "STRING",    mode = "NULLABLE" },
    { name = "amount",    type = "FLOAT",     mode = "NULLABLE" },
    { name = "status",    type = "STRING",    mode = "NULLABLE" },
    { name = "timestamp", type = "TIMESTAMP", mode = "REQUIRED" }
  ]
}

# Création d'une table BigQuery dans le dataset marketing avec des informations confidentielles sur les utilisateurs
module "bigquery_table_user_informations" {
  source = "./bigquery/table"
  project_id = var.project-id-marketing
  dataset_id = "sensitive_information"
  table_id = "user_informations"

  schema = [
    { name = "user_id",     type = "STRING",    mode = "REQUIRED", description = "Identifiant utilisateur unique" },
    { name = "email",       type = "STRING",    mode = "REQUIRED", description = "Adresse email de l'utilisateur" },
    { name = "first_name",  type = "STRING",    mode = "NULLABLE", description = "Prénom" },
    { name = "last_name",   type = "STRING",    mode = "NULLABLE", description = "Nom de famille" },
    { name = "birthdate",   type = "DATE",      mode = "NULLABLE", description = "Date de naissance" },
    { name = "country",     type = "STRING",    mode = "NULLABLE", description = "Pays de résidence" },
    { name = "created_at",  type = "TIMESTAMP", mode = "REQUIRED", description = "Date de création du compte" },
    { name = "is_active",   type = "BOOLEAN",   mode = "NULLABLE", description = "Compte actif ou non" }
  ]
}


             ############   IAM   ############

module "marketing_bigquery_job_user" {
  source     = "./iam/project"
  project_id = var.project-id-marketing
  role       = "roles/bigquery.jobUser"
  member     = "user:${var.data-analyst}"
}

module "marketing_data_analyst_bigquery_data_viewer" {
  source     = "./iam/project"
  
  project_id = var.project-id-marketing
  role       = "roles/bigquery.dataViewer"
  member     = "user:${var.data-analyst}"

  condition_enabled   = true
  condition_title     = "Give access only to low and medium sensitivity data"
  condition_description = "Donne accès seulement aux données de sensibilité faible ou moyenne"
  condition_expression  = <<EOT
resource.matchTagId("${module.tag_sensitivity.tag_key_id}", "${module.tag_sensitivity.tag_values_ids["low"]}") || resource.matchTagId("${module.tag_sensitivity.tag_key_id}", "${module.tag_sensitivity.tag_values_ids["medium"]}")
EOT
}

module "marketing_data_analyst_bigquery_metadata_viewer" {
  source     = "./iam/project"
  
  project_id = var.project-id-marketing
  role       = "roles/bigquery.metadataViewer"
  member     = "user:${var.data-analyst}"

  condition_enabled   = true
  condition_title     = "Give access only to low and medium sensitivity data"
  condition_description = "Donne accès seulement aux données de sensibilité faible ou moyenne"
  condition_expression  = <<EOT
resource.matchTagId("${module.tag_sensitivity.tag_key_id}", "${module.tag_sensitivity.tag_values_ids["low"]}") || resource.matchTagId("${module.tag_sensitivity.tag_key_id}", "${module.tag_sensitivity.tag_values_ids["medium"]}")
EOT
}