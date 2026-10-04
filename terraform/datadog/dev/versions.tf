terraform {
  required_version = ">= 1.7.0"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 4.21"
    }
  }
}

provider "datadog" {}
