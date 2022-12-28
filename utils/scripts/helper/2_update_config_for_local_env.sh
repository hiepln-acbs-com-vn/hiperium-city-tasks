#!/bin/bash

cd "$WORKING_DIR"/src/hiperium-city-tasks-pwa/ || {
  echo "Error moving to the Tasks Service 'frontend' directory."
  exit 1
}

echo ""
echo "Getting information from AWS. Please wait..."

echo ""
authStack=$(aws cloudformation list-stacks --output text \
  --query "StackSummaries[?contains(StackName, 'authHiperiumCityIdP') && (StackStatus=='CREATE_COMPLETE' || StackStatus=='UPDATE_COMPLETE')].[StackName]" \
  --profile "$IDP_AWS_PROFILE")
if [ -z "$authStack" ]; then
  echo "No Tasks Service Identity Provider (IdP) stack found on CloudFormation."
  exit 0
fi
echo "IdP Service Stack found: $authStack"

user_pool_id=$(aws cloudformation describe-stacks   \
  --stack-name "$authStack"                         \
  --query "Stacks[0].Outputs[0].OutputValue"        \
  --output text                                     \
  --profile "$IDP_AWS_PROFILE")
if [ -z "$user_pool_id" ]; then
  echo "No Cognito User Pool found on CloudFormation."
  exit 0
fi
echo "User Pool ID found: $user_pool_id"

cognito_app_client_id_web=$(aws cloudformation describe-stacks  \
  --stack-name "$authStack"                             \
  --query "Stacks[0].Outputs[1].OutputValue"            \
  --output text                                         \
  --profile "$IDP_AWS_PROFILE")
if [ -z "$cognito_app_client_id_web" ]; then
  echo "No Cognito Client ID Web found on CloudFormation."
  exit 0
fi
echo "Cognito Client ID Web: $cognito_app_client_id_web"

echo ""
echo "Updating IdP values in the PWA environment.ts file..."
sed -e "s/AWS_REGION/$AWS_REGION/g; s/COGNITO_USER_POOL_ID/$user_pool_id/g; s/COGNITO_APP_CLIENT_ID_WEB/$cognito_app_client_id_web/g;" \
    "$WORKING_DIR"/utils/scripts/templates/ionic/ionic-environment-local > src/environments/environment.ts
echo "DONE!"

echo ""
echo "Updating IdP values in the Docker-Compose environment file..."
sed -i'.bak' -e "s/AWS_REGION/$AWS_REGION/g; s/COGNITO_USER_POOL_ID/$user_pool_id/g;" \
    "$WORKING_DIR"/utils/docker/compose/dev.env
rm -f "$WORKING_DIR"/utils/docker/compose/dev.env.bak
echo "DONE!"
