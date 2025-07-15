variable "project_id" {
  type        = string
  description = "ID du projet GCP"
}

variable "location" {
  type        = string
  default     = "EU"
}

variable "connection_id" {
  type        = string
  description = "ID de la connexion BigLake"
}
