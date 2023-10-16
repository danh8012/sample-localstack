#!/bin/bash
docker container stop haock_localstack_container
docker container rm haock_localstack_container
docker image rm haock_localstack_image
docker build --rm --progress=plain -t haock_localstack_image:latest .
#docker container run --privileged -tid --publish 4566:4566 --publish 4510-4559:4510-4559 -e DEBUG=1 -v /var/run/docker.sock:/var/run/docker.sock --name haock_localstack_container haock_localstack_image
docker compose up -d
docker exec -it haock_localstack_container awslocal lambda create-function --function-name func-events-example --runtime nodejs18.x --zip-file fileb:///home/localstack/Downloads/function.zip --handler index.handler --role arn:aws:iam::000000000000:role/role-func-events-example
docker exec -it haock_localstack_container awslocal events put-rule --name cron-events-example --schedule-expression 'rate(1 minute)'
docker exec -it haock_localstack_container awslocal lambda add-permission --function-name func-events-example --statement-id cron-events-example --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:us-east-1:000000000000:rule/cron-events-example
docker exec -it haock_localstack_container awslocal events put-targets --rule cron-events-example --targets file:///home/localstack/Downloads/targets.json
docker exec -it haock_localstack_container awslocal logs create-log-group --log-group-name /aws/lambda/func-events-example
docker exec -it haock_localstack_container awslocal logs create-log-stream --log-group-name /aws/lambda/func-events-example --log-stream-name stream-events-example
