# Running

## Set environmental variables

1. Save `.env.example` as `.env` with your correct values
2. Load `.env` by your method of choice


## Verify environmental variables are set

### Before you run `terraform` commands

`echo $TF_VAR_sumologic_access_id`
`echo $TF_VAR_sumologic_access_key`
`echo $TF_VAR_sumologic_notification_email`

### Before you run `curl` commands

`echo $SUMOLOGIC_ENDPOINT`

## Initialize the provider

`terraform init`

## Preview infrastructure changes

`terraform plan -out=tfplan`

## Apply infrastructure changes

`terraform apply "tfplan"`

# Testing

## View Live Tail

1. Go to https://service.sumologic.com/livetail
2. Add `_sourceCategory=terraform*`
3. Click run button

## Send a message

1. Open terminal
2. Run `curl -X POST -H "Content-Type: text/plain" -d "Hello World" $SUMOLOGIC_ENDPOINT`

## Log Search
1. Go to https://service.sumologic.com/log-search
2. Add `_sourceCategory=terraform*`
3. Click search button

## Send 200, 400, and 500 messages from JSON log files
1. Open terminal
2. Run `curl -X POST -H "Content-Type: application/json" -d @example-json-200.log $SUMOLOGIC_ENDPOINT`
3. Run `curl -X POST -H "Content-Type: application/json" -d @example-json-400.log $SUMOLOGIC_ENDPOINT`
4. Run `curl -X POST -H "Content-Type: application/json" -d @example-json-500.log $SUMOLOGIC_ENDPOINT`

This should result in you getting two emails after 5 minutes letting you know the monitor has reached critical and warning status.

Great success!