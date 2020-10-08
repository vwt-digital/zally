#!/bin/bash

set -eo pipefail

if [ "$BRANCH_NAME" != "develop" ]; then
  echo "No branch name specified, or master branch. Specify BRANCH_NAME='develop' to run."
  exit 0
fi

echo "checking argument..."

regcheck=".*yaml.*|.*json.*"

if [[ "$1" =~ $regcheck ]]; then
  echo "starting server..."
  regcheck=".*Started ApplicationKt.*"

  while IFS='' read -r line; do

    echo "$line"
    [[ $line =~ $regcheck ]] || continue
    echo "server seems to have started. beginning linting process..."

    attempt_counter=1

    until jps | grep -v ApplicationKt >/dev/null; do
      if [ ${attempt_counter} -eq 5 ]; then
        echo "max attempts reached to connect with server. failing..."
        exit 1
      fi
      printf "Attempt %s of 4" ${attempt_counter}

      printf "'ApplicationKt' not running, trying again...\n"
      attempt_counter=$((attempt_counter + 1))
      sleep 4
    done

    sleep 4; zally lint "$1"; exit 0
  done < <(java -Xms1024m -Xmx1536m -jar /usr/local/bin/zallyserver.jar)

  echo "server isn't starting correctly..."
  exit 1
fi

echo "argument not optional: json or yaml spec file"
exit 1
