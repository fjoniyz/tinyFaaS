#!/bin/bash

# Set and export the HTTP_PORT environment variable
export HTTP_PORT=2000
export GRPC_PORT=2100
export COAP_PORT=2200
export CONFIG_PORT=3100
export RPROXY_PORT=3200

for i in {1..4}; do
    echo "Cleanup started"
    HTTP_PORT_PID=$(sudo lsof -t -i:$HTTP_PORT)
    GRPC_PORT_PID=$(sudo lsof -t -i:$GRPC_PORT)
    COAP_PORT_PID=$(sudo lsof -t -i:$COAP_PORT)
    CONFIG_PORT_PID=$(sudo lsof -t -i:$CONFIG_PORT)
    RPROXY_PORT_PID=$(sudo lsof -t -i:$RPROXY_PORT)
    sudo kill -9 "$HTTP_PORT_PID"
    sudo kill -9 "$GRPC_PORT_PID"
    sudo kill -9 "$COAP_PORT_PID"
    sudo kill -9 "$CONFIG_PORT_PID"
    sudo kill -9 "$RPROXY_PORT_PID"
    ((HTTP_PORT++))
    ((GRPC_PORT++))
    ((COAP_PORT++))
    ((CONFIG_PORT++))
    ((RPROXY_PORT++))
done
