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
RUN npm install
RUN zip -qr function.zip index.mjs node_modules
RUN ls -ahl /home/sample-localstack/

FROM localstack/localstack:latest
#ENV DEBUG 1
#ENV DOCKER_HOST unix:///var/run/docker.sock
#VOLUME /var/lib/localstack
#VOLUME /var/run/docker.sock
#EXPOSE 4566 4510-4559
RUN mkdir /home/localstack/Downloads
COPY --from=ubuntu_build --chown=localstack:localstack /home/sample-localstack/function.zip /home/localstack/Downloads/
COPY --from=ubuntu_build --chown=localstack:localstack /home/sample-localstack/targets.json /home/localstack/Downloads/