#!/bin/bash

set -eo pipefail

if [ "$BRANCH_NAME" == "master" ]; then
  echo "Skipping Zally in master branch."
  exit 0
fi

echo "checking argument..."

regcheck=".*yaml.*|.*json.*"

if [[ "$1" =~ $regcheck ]]; then

  java -jar /usr/local/bin/zallyserver.jar & sleep 45; zally lint "$1"; exit 0

#  echo "starting server..."
#  regcheck=".*Started ApplicationKt.*"
#
#  while IFS='' read -r line; do
#
#    echo "$line"
#    [[ $line =~ $regcheck ]] || continue
#    echo "server seems to have started. beginning linting process..."
#
#    attempt_counter=0
#    port=8000
#
#    until lsof -i -P -n | grep ".*:${port}" >/dev/null; do
#      if [ ${attempt_counter} -eq 5 ]; then
#        echo "max attempts reached to connect with server. failing..."
#        exit 1
#      fi
#
#      printf "port %s not in use, trying again...\n" "${port}"
#      attempt_counter=$((attempt_counter + 1))
#      sleep 4
#    done
#
#    sleep 4
#    zally lint "$1"
#    exit 0
#  done < <(java -jar /usr/local/bin/zallyserver.jar)
#
#  echo "server isn't starting correctly..."
#  exit 1
fi

echo "argument not optional: json or yaml spec file"
exit 1
