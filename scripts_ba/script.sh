#!/bin/bash

# Set and export the HTTP_PORT environment variable
export HTTP_PORT=2000
export GRPC_PORT=2100
export COAP_PORT=2200
export CONFIG_PORT=3100
export RPROXY_PORT=3200

# Run your Go program
for i in {1..4}; do
    echo "Iteration $i:"
    make &
    sleep 25
    ./scripts/upload.sh "./test/fns/sieve-of-eratosthenes" "sieve" "nodejs" 1
    # Increment the PORT variables
    ((HTTP_PORT++))
    ((GRPC_PORT++))
    ((COAP_PORT++))
    ((CONFIG_PORT++))
    ((RPROXY_PORT++))

    # Export the updated values of the PORT variables
    export HTTP_PORT
    export GRPC_PORT
    export COAP_PORT
    export CONFIG_PORT
    export RPROXY_PORT
done