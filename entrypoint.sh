#!/bin/sh

scriptDir=$(cd $(dirname $0) && pwd)
cd $scriptDir

jekyll --version > /dev/null
exitCode=$?

if [ $exitCode != 0 ]; then
   echo "ERROR: Cannot find jekyll (exitCode: $exitCode)"
   exit 1
fi

if [ ! -d $SITE_SOURCE ]; then
   echo "ERROR: env var SITE_SOURCE does not contain a valid directory"
   exit 1
fi

jekyll serve -s $SITE_SOURCE --disable-disk-cache --host 0.0.0.0
