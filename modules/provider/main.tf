terraform {
  required_providers {
    sumologic = {
      source  = "SumoLogic/sumologic"
      version = ">=2.9.0"
    }
  }
}

provider "sumologic" {
  access_id  = var.sumologic_access_id
  access_key = var.sumologic_access_key
}

variable "sumologic_access_id" {
  description = "Sumo Logic Access ID"
  type        = string
  sensitive   = true
}

variable "sumologic_access_key" {
  description = "Sumo Logic Access Key"
  type        = string
  sensitive   = true
}
