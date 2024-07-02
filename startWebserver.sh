#!/bin/bash

scriptDir=$(cd $(dirname $0) && pwd)
cd $scriptDir

IMAGE_NAME=underwater-camera-project-webpage
IMAGE_VERSION=0.0.1

if [ -z "$(docker images -q $IMAGE_NAME:$IMAGE_VERSION 2> /dev/null)" ]; then
  ./buildDockerImage.sh
fi

docker run -it --rm \
	-v ./docs:/home/jekyll/docs:ro \
	-e SITE_SOURCE=/home/jekyll/docs \
	-p 4000:4000 \
	$IMAGE_NAME:$IMAGE_VERSION
