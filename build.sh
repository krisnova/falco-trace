#!/bin/bash

REGISTRY="krisnova"
NAME_BASE="falco-trace"

function build-push() {
  IMAGE=$REGISTRY/$NAME_BASE-$2:latest
  echo "Directory: $1"
  echo "Image: ${IMAGE}"
  docker build -t $IMAGE $1
  docker push $IMAGE
}

echo "Building base: ${NAME_BASE}"
docker build -t $REGISTRY/$NAME_BASE:latest .
docker push $REGISTRY/$NAME_BASE:latest

build-push example-apps/VulnerableServer/ "vulnerableserver"
build-push example-apps/SSH/ "ssh"
build-push example-apps/BenchmarkFalcoNginx/ "benchmarkfalconginx"

