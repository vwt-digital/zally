#!/bin/bash

set -eo pipefail
echo "checking argument..."
regcheck=".*yaml.*|.*json.*"
if [[ "$1" =~ $regcheck ]]; then
  echo "starting server..."
  regcheck=".*Started ApplicationKt.*"
  while IFS='' read -r line; do
    [[ $line =~ $regcheck ]] || continue
    echo "server seems to have started. beginning linting process..."
    zally lint "$1"
  done < <(java -jar /usr/local/bin/zallyserver.jar)
  echo "server isn't starting correctly..."
  exit 1
fi
echo "argument not optional: json or yaml spec file"
exit 1
