#!/bin/bash

VERSION=1.0
IMAGE=phtcosta/android

docker build --no-cache --build-arg EMULATOR_NAME=Nexus-One-10 -t $IMAGE:$VERSION $(dirname $0)

ID=$(docker images | grep "$IMAGE" | head -n 1 | awk '{print $3}')

docker tag "$ID" $IMAGE:latest
docker tag "$ID" $IMAGE:$VERSION

echo "Imagem criada com sucesso!!!"
