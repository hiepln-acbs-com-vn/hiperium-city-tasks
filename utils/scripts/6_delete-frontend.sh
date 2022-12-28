#!/bin/bash

cd "$WORKING_DIR"/src/hiperium-city-tasks-pwa/ || {
  echo "Error moving to the Tasks Service 'frontend' directory."
  exit 1
}

echo ""
echo "DELETING AMPLIFY APP FROM AWS.."
amplify delete
