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

zally lint "$1"
