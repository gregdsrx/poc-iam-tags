variable "project_id" {
  type        = string
}

variable "dataset_id" {
  type        = string
}

variable "table_id" {
  type        = string
}

variable "gcs_source_uri" {
  type        = string
  description = "Chemin GCS vers les fichiers CSV à lier"
}

variable "connection_name" {
  type        = string
  description = "Nom complet de la connexion BigLake"
}

variable "schema" {
  description = "Schéma de la table BigLake"
  type = list(object({
    name = string
    type = string
    mode = string
  }))
}


