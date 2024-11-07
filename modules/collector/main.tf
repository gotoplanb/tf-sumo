variable "collector_name" {
  description = "Name of the Sumo Logic collector"
  type        = string
  default     = "My Terraform Collector"
}

resource "sumologic_collector" "my_collector" {
  name        = var.collector_name
  description = "Collector created by Terraform"
  category    = "terraform/collectors"
  timezone    = "UTC"

  fields = {
    environment = "production"
  }
}
