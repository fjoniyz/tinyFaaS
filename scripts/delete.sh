#!/bin/bash

#delete.sh function-name

set -e

if ! command -v curl &> /dev/null
then
    echo "curl could not be found but is a pre-requisite for this script"
    exit
fi

env_variable_value="$CONFIG_PORT"

curl "http://localhost:$env_variable_value/delete" --data "{\"name\": \"$1\"}"
