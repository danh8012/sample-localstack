#!/bin/bash
docker container stop haock_localstack_main
docker container rm haock_localstack_main
git clone git@github.com:localstack/localstack.git
cd localstack
export LOCALSTACK_DOCKER_NAME=haock_localstack_main
docker compose up -d
git clone git@github.com:danh8012/sample-localstack.git
docker exec -it haock_localstack_main mkdir /home/localstack/Downloads/
cd sample-localstack
docker cp index.mjs haock_localstack_main:/home/localstack/Downloads/
docker cp package.json haock_localstack_main:/home/localstack/Downloads/
docker cp targets.json haock_localstack_main:/home/localstack/Downloads/
docker exec -it haock_localstack_main bash -c "cd /home/localstack/Downloads/ && npm install && zip -qr function.zip index.mjs node_modules"
docker exec -it haock_localstack_main awslocal lambda create-function --function-name func-events-example --runtime nodejs18.x --zip-file fileb:///home/localstack/Downloads/function.zip --handler index.handler --role arn:aws:iam::000000000000:role/role-func-events-example
docker exec -it haock_localstack_main awslocal events put-rule --name cron-events-example --schedule-expression 'rate(1 minute)'
docker exec -it haock_localstack_main awslocal lambda add-permission --function-name func-events-example --statement-id cron-events-example --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:us-east-1:000000000000:rule/cron-events-example
docker exec -it haock_localstack_main awslocal events put-targets --rule cron-events-example --targets file:///home/localstack/Downloads/targets.json
docker exec -it haock_localstack_main awslocal logs create-log-group --log-group-name /aws/lambda/func-events-example
docker exec -it haock_localstack_main awslocal logs create-log-stream --log-group-name /aws/lambda/func-events-example --log-stream-name stream-events-example