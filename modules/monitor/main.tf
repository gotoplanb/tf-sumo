variable "notification_email" {
  description = "Email recipient for notifications"
  type        = string
}

resource "sumologic_monitor" "status_code_monitor" {
  name              = "HTTP Status Code Monitor"
  description       = "Monitor for 4xx and 5xx status codes in HTTP logs"
  type              = "MonitorsLibraryMonitor"
  content_type      = "Monitor"
  monitor_type      = "Logs"
  evaluation_delay  = "5m"
  is_disabled       = false
  tags = {
    team        = "monitoring"
    application = "sumologic"
  }

  queries {
    row_id = "A"
    query  = "_sourceCategory=terraform* | where status_code matches \"4*\" OR status_code matches \"5*\""
  }

  trigger_conditions {
    logs_static_condition {
      critical {
        time_range = "5m"
        alert {
          threshold      = 3.0
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

  notifications {
    notification {
      connection_type = "Email"
      recipients = [
        var.notification_email
      ]
      subject      = "Monitor Alert: {{TriggerType}} on {{Name}}"
      time_zone    = "PST"
      message_body = "Triggered {{TriggerType}} Alert on {{Name}}: {{QueryURL}}"
    }
    run_for_trigger_types = ["Critical", "ResolvedCritical", "Warning"]
  }
}
