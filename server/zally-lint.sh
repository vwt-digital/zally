#!/bin/bash

set -eo pipefail
echo "checking argument"
ls -l
if [ "$1" == "" ]; then
    echo "argument not optional: spec file"
    exit 1
fi
echo "starting linting process"
java -jar /usr/local/bin/zallyserver.jar & sleep 80; zally lint "$1"
# TODO - Use something else to wait for the server^
