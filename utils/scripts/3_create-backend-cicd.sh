#!/bin/bash

cd "$WORKING_DIR" || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

read -r -p "Please, enter the <AWS Profile> for the service Deployment tools: [profile $AWS_PROFILE] " deployment_profile_name
if [ "$deployment_profile_name" ]; then
  AWS_PROFILE=$deployment_profile_name
  export AWS_PROFILE
fi

echo ""
echo "DEPLOYING COPILOT PIPELINE ON AWS..."
copilot pipeline deploy             \
  --app hiperium-city-tasks         \
  --name "api-$TASK_SERVICE_ENV"    \
  --yes
echo "DONE!"
