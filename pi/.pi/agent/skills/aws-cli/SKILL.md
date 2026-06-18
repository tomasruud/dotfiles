---
name: aws-cli
description:
  Interact with AWS using the aws CLI. Query CloudWatch logs and metrics,
  manage Lambda functions, work with SQS queues, EventBridge rules, RDS
  databases, and API Gateway. Use when the user asks about AWS resources,
  logs, deployments, or infrastructure debugging.
---

# AWS CLI

Use `aws` via bash to interact with AWS services. Use `--profile <name>` to
select an AWS profile and `--region <region>` to target a specific region.

Run `aws <service> <command> help` for full details on any command.

## CloudWatch Logs

### List log groups

```bash
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/my-func"
```

### Tail logs (live)

```bash
aws logs tail "/aws/lambda/my-func" --follow
aws logs tail "/aws/lambda/my-func" --since 1h
aws logs tail "/aws/lambda/my-func" --since 30m --filter-pattern "ERROR"
```

### Query logs with Insights

```bash
aws logs start-query \
  --log-group-name "/aws/lambda/my-func" \
  --start-time $(date -d '1 hour ago' +%s) \
  --end-time $(date +%s) \
  --query-string 'fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 50'

# Then fetch results
aws logs get-query-results --query-id "QUERY_ID"
```

### Get log events

```bash
aws logs get-log-events \
  --log-group-name "/aws/lambda/my-func" \
  --log-stream-name "stream-name" \
  --limit 100
```

## CloudWatch Metrics

### List metrics

```bash
aws cloudwatch list-metrics --namespace AWS/Lambda --metric-name Errors
```

### Get metric statistics

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Errors \
  --dimensions Name=FunctionName,Value=my-func \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-02T00:00:00Z \
  --period 3600 \
  --statistics Sum
```

### Describe alarms

```bash
aws cloudwatch describe-alarms --alarm-name-prefix "my-service"
aws cloudwatch describe-alarms --state-value ALARM
```

## Lambda

### List and view functions

```bash
aws lambda list-functions --query "Functions[].FunctionName"
aws lambda get-function --function-name my-func
aws lambda get-function-configuration --function-name my-func
```

### Invoke a function

```bash
aws lambda invoke --function-name my-func --payload '{"key":"value"}' output.json
cat output.json
```

### Update function code

```bash
aws lambda update-function-code --function-name my-func --zip-file fileb://deploy.zip
```

### Update function configuration

```bash
aws lambda update-function-configuration \
  --function-name my-func \
  --timeout 30 \
  --memory-size 256 \
  --environment "Variables={KEY=value}"
```

### View event source mappings (SQS triggers etc.)

```bash
aws lambda list-event-source-mappings --function-name my-func
```

## SQS

### List and view queues

```bash
aws sqs list-queues --queue-name-prefix "my-service"
aws sqs get-queue-attributes --queue-url QUEUE_URL --attribute-names All
```

### Send a message

```bash
aws sqs send-message --queue-url QUEUE_URL --message-body '{"key":"value"}'
```

### Receive and delete messages

```bash
aws sqs receive-message --queue-url QUEUE_URL --max-number-of-messages 10 --wait-time-seconds 5
aws sqs delete-message --queue-url QUEUE_URL --receipt-handle HANDLE
```

### Purge a queue

```bash
aws sqs purge-queue --queue-url QUEUE_URL
```

### Dead letter queue redrive

```bash
# Check DLQ message count
aws sqs get-queue-attributes --queue-url DLQ_URL --attribute-names ApproximateNumberOfMessages
```

## EventBridge

### List rules

```bash
aws events list-rules --event-bus-name my-bus
aws events list-rules --name-prefix "my-service"
```

### View a rule and its targets

```bash
aws events describe-rule --name my-rule --event-bus-name my-bus
aws events list-targets-by-rule --rule my-rule --event-bus-name my-bus
```

### Put events (publish)

```bash
aws events put-events --entries '[{
  "Source": "my-service",
  "DetailType": "MyEvent",
  "Detail": "{\"key\":\"value\"}",
  "EventBusName": "my-bus"
}]'
```

### Enable/disable rules

```bash
aws events enable-rule --name my-rule --event-bus-name my-bus
aws events disable-rule --name my-rule --event-bus-name my-bus
```

## RDS

### List and describe instances

```bash
aws rds describe-db-instances
aws rds describe-db-instances --db-instance-identifier my-db
aws rds describe-db-clusters --db-cluster-identifier my-cluster
```

### Check instance status

```bash
aws rds describe-db-instances \
  --query "DBInstances[].{ID:DBInstanceIdentifier,Status:DBInstanceStatus,Engine:Engine,Class:DBInstanceClass}"
```

### View recent events

```bash
aws rds describe-events --source-type db-instance --duration 60
aws rds describe-events --source-identifier my-db --source-type db-instance
```

### Snapshots

```bash
aws rds describe-db-snapshots --db-instance-identifier my-db
aws rds create-db-snapshot --db-instance-identifier my-db --db-snapshot-identifier my-snapshot
```

### Logs

```bash
aws rds describe-db-log-files --db-instance-identifier my-db
aws rds download-db-log-file-portion --db-instance-identifier my-db --log-file-name error/mysql-error.log
```

## API Gateway

### REST APIs (v1)

```bash
aws apigateway get-rest-apis
aws apigateway get-rest-api --rest-api-id API_ID
aws apigateway get-resources --rest-api-id API_ID
aws apigateway get-stages --rest-api-id API_ID
aws apigateway get-deployments --rest-api-id API_ID
```

### HTTP APIs (v2)

```bash
aws apigatewayv2 get-apis
aws apigatewayv2 get-api --api-id API_ID
aws apigatewayv2 get-routes --api-id API_ID
aws apigatewayv2 get-stages --api-id API_ID
aws apigatewayv2 get-integrations --api-id API_ID
```

## Tips

- Use `--output table` for human-readable output, `--output json` for scripting
- Use `--query` (JMESPath) to filter and shape output inline
- Use `--profile` and `--region` to target specific accounts/regions
- Use `--no-paginate` or `--max-items` to control pagination
- Pipe JSON output through `jq` for advanced filtering
- Use `aws sts get-caller-identity` to verify which account/role you're using
