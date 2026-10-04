variable "location" {
  description = "Azure region for the development environment."
  type        = string
  default     = "eastus"
}

variable "app_name" {
  description = "Short application/platform name used in Azure resource naming."
  type        = string
  default     = "observe"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Datadog unified service name / Spring Boot service name."
  type        = string
  default     = "eligibility-api"
}

variable "container_port" {
  description = "Spring Boot container port."
  type        = number
  default     = 8080
}

variable "bootstrap_image" {
  description = "Public bootstrap image used until CI pushes the Java image to ACR."
  type        = string
  default     = "mcr.microsoft.com/k8se/quickstart:latest"
}

variable "min_replicas" {
  description = "Minimum ACA replicas."
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum ACA replicas."
  type        = number
  default     = 3
}

variable "vnet_address_space" {
  description = "VNet address space."
  type        = list(string)
  default     = ["10.40.0.0/16"]
}

variable "aca_subnet_address_prefixes" {
  description = "Dedicated subnet for Azure Container Apps environment."
  type        = list(string)
  default     = ["10.40.0.0/23"]
}

variable "tags" {
  description = "Additional Azure resource tags."
  type        = map(string)
  default = {
    owner       = "platform"
    application = "eligibility-api"
    managed_by  = "terraform"
  }
}
