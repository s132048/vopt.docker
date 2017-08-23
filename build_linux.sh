#!/bin/bash

VM="vopt"
IMAGE_NAME="veranostech/vopt"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong... Press any key to continue..."' EXIT

read -p "tag (default \"latest\"): " TAG
if [ -z "$TAG" ]; then
  TAG=latest
fi

COMMAND="docker build --rm=true -t $IMAGE_NAME:$TAG . 2>&1 | tee $(date +"%Y%m%d-%H%M%S").log"

eval ${COMMAND}
