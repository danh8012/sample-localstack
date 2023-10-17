#!/bin/bash
awslocal lambda create-function --function-name func-events-example --runtime nodejs18.x --zip-file fileb:///home/localstack/Downloads/function.zip --handler index.handler --role arn:aws:iam::000000000000:role/role-func-events-example
awslocal events put-rule --name cron-events-example --schedule-expression 'rate(1 minute)'
awslocal lambda add-permission --function-name func-events-example --statement-id cron-events-example --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:us-east-1:000000000000:rule/cron-events-example
awslocal events put-targets --rule cron-events-example --targets file:///home/localstack/Downloads/targets.json
awslocal logs create-log-group --log-group-name /aws/lambda/func-events-example
awslocal logs create-log-stream --log-group-name /aws/lambda/func-events-example --log-stream-name stream-events-example