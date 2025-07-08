variable "parent_project" {
  description = "ID du projet parent où seront créés les tags"
  type        = string
}

variable "tag_key_short_name" {
  description = "Nom court de la clé de tag"
  type        = string
}

variable "tag_key_description" {
  description = "Description de la clé de tag"
  type        = string
  default     = ""
}

variable "tag_values" {
  type = list(object({
    short_name  = string
    description = string
  }))
  default = []
}