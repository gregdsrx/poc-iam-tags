variable "dataset_id" {
  description = "ID du projet GCP"
  type        = string
}

variable "project_id" {
  type        = string
}

variable "role" {
  description = "Rôle IAM à assigner"
  type        = string
}

variable "member" {
  description = "Membre IAM (user, group, serviceAccount, etc.)"
  type        = string
}

variable "condition_enabled" {
  description = "Activer la condition IAM ?"
  type        = bool
  default     = false
}

variable "condition_title" {
  description = "Titre de la condition IAM"
  type        = string
  default     = ""
}

variable "condition_description" {
  description = "Description de la condition IAM"
  type        = string
  default     = ""
}

variable "condition_expression" {
  description = "Expression conditionnelle IAM"
  type        = string
  default     = ""
}
