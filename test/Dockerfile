FROM ubuntu:22.04 as ubuntu_build
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y --allow-unauthenticated
RUN apt-get install -y tcl
RUN apt-get install -y git-all
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y zip
WORKDIR /home/
RUN git clone https://github.com/danh8012/sample-localstack.git
WORKDIR /home/sample-localstack
RUN ls -ahl
RUN npm install
RUN zip -qr function.zip index.mjs node_modules
RUN chmod 777 function.zip
RUN chmod 777 targets.json
RUN ls -ahl

FROM localstack/localstack:latest
RUN mkdir /home/localstack/Downloads
COPY --from=ubuntu_build /home/sample-localstack/function.zip /home/localstack/Downloads/
COPY --from=ubuntu_build /home/sample-localstack/targets.json /home/localstack/Downloads/
RUN chown localstack:localstack /home/localstack/Downloads/function.zip
RUN chown localstack:localstack /home/localstack/Downloads/targets.json
RUN awslocal lambda create-function --function-name func-events-example --runtime nodejs18.x --zip-file fileb:///home/localstack/Downloads/function.zip --handler index.handler --role arn:aws:iam::000000000000:role/role-func-events-example
RUN awslocal events put-rule --name cron-events-example --schedule-expression 'rate(1 minute)'
RUN awslocal lambda add-permission --function-name func-events-example --statement-id cron-events-example --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn arn:aws:events:us-east-1:000000000000:rule/cron-events-example
RUN awslocal events put-targets --rule cron-events-example --targets file:///home/localstack/Downloads/targets.json
RUN awslocal logs create-log-group --log-group-name /aws/lambda/func-events-example
RUN awslocal logs create-log-stream --log-group-name /aws/lambda/func-events-example --log-stream-name stream-events-example
