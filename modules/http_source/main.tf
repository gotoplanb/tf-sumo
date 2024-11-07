variable "collector_id" {
  description = "The ID of the Sumo Logic collector to associate with the HTTP source"
  type        = string
}

resource "sumologic_http_source" "my_http_source" {
  name                         = "My HTTP Source"
  collector_id                 = var.collector_id
  message_per_request          = false
  multiline_processing_enabled = true
  category                     = "terraform/http_sources"
  description                  = "HTTP Source for Terraform collector"
}
