#!/bin/bash

cd "$WORKING_DIR" || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

accountId=$(aws configure get sso_account_id --profile "$AWS_PROFILE")
if [ -z "$accountId" ]; then
  echo "Error getting the SSO Account ID..."
  exit 1
fi

echo ""
echo "DEPLOYING COPILOT PIPELINE ON AWS..."
copilot pipeline deploy             \
  --app hiperium-city-tasks         \
  --name "api-$TASK_SERVICE_ENV"    \
  --yes

echo ""
echo "UPDATING CODEBUILD COMPUTE TYPE ON AWS..."
sed -e "s/TASK_SERVICE_ENV/$TASK_SERVICE_ENV/g; s/timer-service-account-id/$accountId/g" \
  utils/scripts/templates/aws/codebuild-updated-config-arm64 > updated-codebuild-project-config.json
aws codebuild update-project --cli-input-json file://updated-codebuild-project-config.json
rm -f updated-codebuild-project-config.json

echo ""
echo "DONE!"
