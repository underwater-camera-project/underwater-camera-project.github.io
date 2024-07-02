#!/bin/bash

scriptDir=$(cd $(dirname $0) && pwd)
cd $scriptDir

docker build -t underwater-camera-project-webpage:0.0.1 .
