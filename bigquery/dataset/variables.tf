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
