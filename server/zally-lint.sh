#!/bin/bash

set -eo pipefail

if [ "$BRANCH_NAME" != "develop" ]; then
  echo "Might be running on a production environment... Specify BRANCH_NAME='develop' to run."
  exit 0
fi

check_file_type=".*yaml.*|.*json.*"

if ! [[ "$1" =~ $check_file_type ]]; then
  echo "argument not optional: json or yaml spec file"
  exit 1
fi

check_started=".*Started ApplicationKt.*"

while IFS='' read -r line; do

  echo "$line"
  [[ $line =~ $check_started ]] || continue

  echo "'ApplicationKt' seems to have started, but we'll check if it is still running..."

  attempt_counter=1
  while ! jps | grep zallyserver.jar || ! lsof -i :8080; do
    if [ ${attempt_counter} -eq 6 ]; then
      echo "max attempts reached to connect with server. failing..."
      exit 1
    fi
    printf "Attempt %s of 5\n" ${attempt_counter}

    printf "'ApplicationKt' not running, trying again...\n"
    attempt_counter=$((attempt_counter + 1))
    sleep 4
  done

  sleep 4
  zally lint "$1"
  exit 0
done < <(java -Xms1024m -Xmx1536m -jar -Xmx1024m -Xmx1536m /usr/local/bin/zallyserver.jar)

echo "server isn't starting correctly..."
exit 1
