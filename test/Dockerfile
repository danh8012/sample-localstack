FROM localstack/localstack:latest
RUN mkdir /home/localstack/Downloads
COPY --chown=localstack:localstack ./function.zip /home/localstack/Downloads/
COPY --chown=localstack:localstack ./targets.json /home/localstack/Downloads/
COPY ./init-aws.sh /etc/localstack/init/ready.d/