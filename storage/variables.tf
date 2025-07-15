variable "project" {
  type        = string
  description = "ID du projet GCP où sera créé le bucket"
}

variable "name" {
  type        = string
  description = "Nom du bucket"
}

variable "location" {
  type        = string
  default     = "EU"
  description = "Région du bucket"
}

variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = "Classe de stockage (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
}

variable "lifecycle_rules" {
  type        = list(object({
    action = object({
      type = string
    })
    condition = object({
      age = number
    })
  }))
  default     = []
  description = "Liste des règles de cycle de vie pour le bucket"
}
