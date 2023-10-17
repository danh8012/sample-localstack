#!/bin/bash
docker container stop haock_localstack_container
docker container rm haock_localstack_container
docker image rm haock_localstack_image
docker build --rm --progress=plain -t haock_localstack_image:latest .
docker compose up -d