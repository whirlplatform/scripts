#!/usr/bin/env bash

docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}

docker build -t whirl:${TAG}-app --target app --build-arg TAG=${TAG} -f docker/Download.Dockerfile .
docker build -t whirl:${TAG}-editor --target editor --build-arg TAG=${TAG} -f docker/Download.Dockerfile .
docker build -t whirl:${TAG}-all --target all --build-arg TAG=${TAG} -f docker/Download.Dockerfile .

docker tag whirl:${TAG}-app otlichnosti/whirl:${TAG}-app
docker tag whirl:${TAG}-editor otlichnosti/whirl:${TAG}-editor
docker tag whirl:${TAG}-all otlichnosti/whirl:${TAG}-all

docker push otlichnosti/whirl:${TAG}-app
docker push otlichnosti/whirl:${TAG}-editor
docker push otlichnosti/whirl:${TAG}-all