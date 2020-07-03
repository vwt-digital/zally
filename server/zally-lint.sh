#!/bin/bash

set -eo pipefail
echo "checking argument..."

regcheck=".*yaml.*|.*json.*"

if [[ "$1" =~ $regcheck ]]; then

  echo "starting server..."
  regcheck=".*Started ApplicationKt.*"

  while IFS='' read -r line; do

    echo "$line"
    [[ $line =~ $regcheck ]] || continue
    echo "server seems to have started. beginning linting process..."

    attempt_counter=0

    until netcat -z -w 1 localhost 7979; do
        if [ ${attempt_counter} -eq 5 ];then
          echo "max attempts reached to connect with server. failing..."
          exit 1
        fi

        printf 'port 7979 not in use, trying again...\n'
        attempt_counter=$((attempt_counter+1))
        sleep 4
    done

    sleep 2; zally lint "$1"; exit 0

  done < <(java -jar /usr/local/bin/zallyserver.jar)

  echo "server isn't starting correctly..."
  exit 1

fi

echo "argument not optional: json or yaml spec file"
exit 1
