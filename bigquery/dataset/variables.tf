variable "project_id" {
  type        = string
  description = "ID du projet GCP"
}

variable "dataset_id" {
  type        = string
  description = "Nom du dataset BigQuery"
}

variable "location" {
  type        = string
  default     = "EU"
}

variable "tag_value" {
  description = "Valeur de tag à associer à la table"
  type = string
}