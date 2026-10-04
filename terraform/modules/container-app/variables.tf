variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "container_app_environment_id" { type = string }

variable "image" { type = string }
variable "target_port" { type = number }

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 3
}

variable "revision_mode" {
  type    = string
  default = "Multiple"

  validation {
    condition     = contains(["Single", "Multiple"], var.revision_mode)
    error_message = "revision_mode must be Single or Multiple."
  }
}

variable "external_ingress" {
  type    = bool
  default = true
}

variable "managed_identity_id" { type = string }
variable "acr_login_server" { type = string }

variable "datadog_api_key_secret_id" {
  description = "Versionless Key Vault secret URI used by ACA for DD_API_KEY."
  type        = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "enable_application_probes" {
  type    = bool
  default = false
}

variable "liveness_path" {
  type    = string
  default = "/api/health/live"
}

variable "readiness_path" {
  type    = string
  default = "/api/health/ready"
}

variable "tags" {
  type    = map(string)
  default = {}
}
