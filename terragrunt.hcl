# Configure remote state if needed
# remote_state {
#   backend = "s3"
#   config = {
#     bucket = "your-s3-bucket"
#     key    = "path/to/terraform.tfstate"
#     region = "your-region"
#   }
# }

terraform {
  source = "./modules"
}

inputs = {
  sumologic_access_id         = get_env("TF_VAR_sumologic_access_id", "")
  sumologic_access_key        = get_env("TF_VAR_sumologic_access_key", "")
  notification_email          = get_env("TF_VAR_sumologic_notification_email", "")
}
