#!/bin/bash

# upload.sh folder-name name env threads

set -e

if ! command -v curl &> /dev/null
then
    echo "curl could not be found but is a pre-requisite for this script"
    exit
fi

if ! command -v zip &> /dev/null
then
    echo "zip could not be found but is a pre-requisite for this script"
    exit
fi

if ! command -v base64 &> /dev/null
then
    echo "base64 could not be found but is a pre-requisite for this script"
    exit
fi

node runtimes/nodejs/portReader.js

pushd "$1" >/dev/null || exit

env_variable_value="$CONFIG_PORT"

curl http://localhost:$env_variable_value/upload --data "{\"name\": \"$2\", \"env\": \"$3\", \"threads\": $4, \"zip\": \"$(zip -r - ./* | base64 | tr -d '\n')\"}"
popd >/dev/null || exit
