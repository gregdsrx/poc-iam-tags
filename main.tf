terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.42.0"
    }
  }
}

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

module "tag_sensitivity" {
  source = "./tags"

  parent_project      = var.project-id-marketing
  tag_key_short_name  = "sensitivity"
  tag_key_description = "Tag clé pour la confidentalité des données"

  tag_values = [
    { short_name = "high", description = "High sensitivity" },
    { short_name = "low", description = "Low sensitivity" }
  ]
}

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

module "bigquery_dataset_marketing" {
  source = "./bigquery/dataset"

  project_id = var.project-id-marketing
  dataset_id = "marketing_dataset"
  location   = "EU"
}

module "bigquery_dataset_sales" {
  source = "./bigquery/dataset"

  project_id = var.project-id-sales
  dataset_id = "sales_dataset"
  location   = "EU"
}

module "bigquery_connection_marketing" {
  source = "./bigquery/connection"

  project_id   = var.project-id-marketing
  connection_id = "marketing_biglake_connection"
  location     = "EU"
}

module "bigquery_connection_sales" {
  source = "./bigquery/connection"

  project_id   = var.project-id-sales
  connection_id = "sales_biglake_connection"
  location     = "EU"
}

module "bigquery_table_marketing" {
  source = "./bigquery/table"

  project_id       = var.project-id-marketing
  dataset_id       = module.bigquery_dataset_marketing.dataset_id
  table_id         = "marketing_external_table"
  gcs_source_uri = "gs://${module.bucket_raw_data_marketing.bucket_name}/*"
  connection_name  = module.bigquery_connection_marketing.connection_id

  schema = [
    { name = "user_id",   type = "STRING", mode = "REQUIRED" },
    { name = "email",     type = "STRING", mode = "NULLABLE" },
    { name = "source",    type = "STRING", mode = "NULLABLE" },
    { name = "campaign",  type = "STRING", mode = "NULLABLE" },
    { name = "timestamp", type = "TIMESTAMP", mode = "REQUIRED" }
  ]

}

module "bigquery_table_sales" {
  source = "./bigquery/table"

  project_id       = var.project-id-sales
  dataset_id       = module.bigquery_dataset_sales.dataset_id
  table_id         = "sales_external_table"
  gcs_source_uri =  "gs://${module.bucket_raw_data_sales.bucket_name}/*"
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
