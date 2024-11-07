# Prerequisites
1. `brew install terraform`
1. `brew install terragrunt`

# Running

## Set environmental variables

1. Save `.env.example` as `.env` with your correct values
2. Load `.env` by your method of choice. Example: `export $(cat .env | xargs)`

## Verify environmental variables are set

### Before you run `terraform` commands

1. `echo $TF_VAR_sumologic_access_id`
1. `echo $TF_VAR_sumologic_access_key`
1. `echo $TF_VAR_sumologic_notification_email`

### Before you run `curl` commands

`echo $SUMOLOGIC_ENDPOINT`

## Initialize the provider

`terragrunt init`

## Preview infrastructure changes

`terragrunt plan -out=tfplan`

## Apply infrastructure changes

`terragrunt apply "tfplan"`

# Testing

## View Live Tail

1. Go to https://service.sumologic.com/livetail
1. Add `_sourceCategory=terraform*`
1. Click run button

## Send a message

1. Open terminal
1. Run `curl -X POST -H "Content-Type: text/plain" -d "Hello World" $SUMOLOGIC_ENDPOINT`

## Log Search
1. Go to https://service.sumologic.com/log-search
1. Add `_sourceCategory=terraform*`
1. Click search button

## Send 200, 400, and 500 messages from JSON log files
1. Open terminal
1. Run `curl -X POST -H "Content-Type: application/json" -d @./examples/example-json-200.log $SUMOLOGIC_ENDPOINT`
1. Run `curl -X POST -H "Content-Type: application/json" -d @./examples/example-json-400.log $SUMOLOGIC_ENDPOINT`
1. Run `curl -X POST -H "Content-Type: application/json" -d @./examples/example-json-500.log $SUMOLOGIC_ENDPOINT`

This should result in you getting two emails after 5 minutes letting you know the monitor has reached critical and warning status.

Great success!