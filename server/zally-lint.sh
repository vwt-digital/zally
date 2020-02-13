#!/bin/bash

set -eo pipefail
echo "checking argument..."
if [ "$1" == "" ]; then
    echo "argument not optional: spec file"
    exit 1
fi
echo "starting server..."
regcheck=".*Started ApplicationKt.*"
while IFS='' read -r line
do
  [[ $line =~ $regcheck ]] || continue
  echo "server seems to have started. beginning linting process..."
  zally lint "$1"
done < <(java -jar /usr/local/bin/zallyserver.jar)
echo "server isn't starting correctly..."
exit 1
