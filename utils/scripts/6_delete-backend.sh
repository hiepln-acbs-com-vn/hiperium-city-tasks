#!/bin/bash

cd "$WORKING_DIR" || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

echo ""
echo "DELETING API GATEWAY FROM AWS.."
aws cloudformation delete-stack   \
  --stack-name hiperium-city-tasks-api-gw
echo "Wait a moment please..."
sleep 45
echo "DONE!"

echo ""
echo "DELETING COPILOT APP FROM AWS.."
copilot app delete --yes

# Restore the .workspace file to its original state. Copilot CLI deletes this file.
git restore copilot/.workspace

echo ""
echo "DONE!"
