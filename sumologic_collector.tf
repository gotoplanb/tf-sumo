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

variable "sumologic_notification_email" {
  description = "Sumo Logic Monitor Notification Recipient"
  type        = string
  sensitive   = false 
}

# Create a Sumo Logic Collector
resource "sumologic_collector" "my_collector" {
  name           = "My Terraform Collector"
  description    = "Collector created by Terraform"
  category       = "terraform/collectors"
  timezone       = "UTC" 

  # Optional configuration settings
  fields = {
    environment = "production"
  }
}

# Create a Sumo Logic HTTP Source
resource "sumologic_http_source" "my_http_source" {
  name                          = "My HTTP Source"
  collector_id                  = sumologic_collector.my_collector.id
  message_per_request           = false
  multiline_processing_enabled  = true
  category                      = "terraform/http_sources"
  description                   = "HTTP Source for Terraform collector"
}

# Create a Sumo Logic Monitor
resource "sumologic_monitor" "status_code_monitor" {
  name              = "HTTP Status Code Monitor"
  description       = "Monitor for 4xx and 5xx status codes in HTTP logs"
  type              = "MonitorsLibraryMonitor"
  content_type      = "Monitor"
  monitor_type      = "Logs"
  evaluation_delay  = "5m"
  is_disabled       = false
  tags = {
    "team"        = "monitoring"
    "application" = "sumologic"
  }

  # Define the log query
  queries {
    row_id = "A"
    query  = "_sourceCategory=terraform* | where status_code matches \"4*\" OR status_code matches \"5*\""
  }

  # Trigger conditions for critical and warning levels
  trigger_conditions {
    logs_static_condition {
      critical {
        time_range = "5m"
        alert {
          threshold      = 1.0
          threshold_type = "GreaterThan"
        }
        resolution {
          threshold      = 1.0
          threshold_type = "LessThanOrEqual"
        }
      }
      warning {
        time_range = "5m"
        alert {
          threshold      = 1.0
          threshold_type = "GreaterThan"
        }
        resolution {
          threshold      = 1.0
          threshold_type = "LessThanOrEqual"
        }
      }
    }
  }

  # Notification settings
  notifications {
    notification {
      connection_type = "Email"
      recipients = [
        var.sumologic_notification_email
      ]
      subject      = "Monitor Alert: {{TriggerType}} on {{Name}}"
      time_zone    = "PST"
      message_body = "Triggered {{TriggerType}} Alert on {{Name}}: {{QueryURL}}"
    }
    run_for_trigger_types = ["Critical", "ResolvedCritical", "Warning"]
  }
}
