#!/bin/bash

# Number of parallel requests
num_requests=4

# API endpoint
api_endpoint="http://localhost:9100/function/sieve"

# Function to send a single request
send_request() {
  local start_time=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$start_time] Sending request..."
  curl -s "$api_endpoint" &
}

# Record the start time
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$start_time] Starting $num_requests parallel requests to $api_endpoint"

# Loop to send parallel requests
for ((i = 1; i <= num_requests; i++)); do
  send_request
done

# Wait for all background jobs to finish
wait

# Record the end time
end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "[$end_time] All requests completed"

