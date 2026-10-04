variable "service_name" {
  description = "Datadog unified service name."
  type        = string
  default     = "eligibility-api"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "dev"
}

variable "team" {
  description = "Owning team tag."
  type        = string
  default     = "platform"
}

variable "endpoint_failure_threshold_5m" {
  description = "Example count threshold for endpoint failures over 5 minutes."
  type        = number
  default     = 5
}

variable "server_error_threshold_5m" {
  description = "Example count threshold for HTTP 5xx events over 5 minutes."
  type        = number
  default     = 3
}

variable "login_failure_threshold_5m" {
  description = "Example count threshold for failed login events over 5 minutes."
  type        = number
  default     = 5
}

variable "latency_p95_ms_threshold" {
  description = "Example p95 latency threshold in milliseconds."
  type        = number
  default     = 1000
}

variable "availability_slo_target" {
  description = "30-day availability SLO target."
  type        = number
  default     = 99.9
}
