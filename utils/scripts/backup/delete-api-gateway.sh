#!/bin/bash

cd "$WORKING_DIR" || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

echo ""
echo "DELETING API GATEWAY FROM AWS..."
aws cloudformation delete-stack   \
  --stack-name hiperium-city-tasks-api-gw

echo "Please, wait a moment while API Gateway is deleted..."
sleep 30
echo "DONE!"
