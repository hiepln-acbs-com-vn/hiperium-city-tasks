#!/bin/bash

cd "$WORKING_DIR" || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

read -r -p 'Please, enter the AWS <IdP Profile> used to deploy the Hiperium IdP Service: [default idp-pre] ' idp_profile_name
if [ -z "$idp_profile_name" ]; then
  idp_profile_name='idp-pre'
fi

echo ""
echo "Getting information from AWS. Please wait..."

echo ""
authStack=$(aws cloudformation list-stacks --output text \
  --query "StackSummaries[?contains(StackName, 'authHiperiumCityIdP') && (StackStatus=='CREATE_COMPLETE' || StackStatus=='UPDATE_COMPLETE')].[StackName]" \
  --profile "$idp_profile_name")
if [ -z "$authStack" ]; then
  echo "No Tasks Service Identity Provider (IdP) stack found on CloudFormation."
  exit 0
fi
echo "IdP Service Stack found: $authStack"

user_pool_id=$(aws cloudformation describe-stacks   \
  --stack-name "$authStack"                         \
  --query "Stacks[0].Outputs[0].OutputValue"        \
  --output text                                     \
  --profile "$idp_profile_name")
if [ -z "$user_pool_id" ]; then
  echo "No Cognito User Pool found on CloudFormation."
  exit 0
fi
echo "User Pool ID found: $user_pool_id"

echo ""
echo "UPDATING API MANIFEST FILE..."
sed -e "s/aws_region/$AWS_REGION/g; s/cognito_user_pool_id/$user_pool_id/g" \
  utils/scripts/templates/copilot/manifest-arm64 > copilot/api/manifest.yml
echo "DONE!"

echo ""
echo "INIT COPILOT IAM ROLES ON AWS..."
copilot init                    \
  --name api                    \
  --app hiperium-city-tasks     \
  --type 'Backend Service'

echo ""
echo "INIT COPILOT ENVIRONMENT (ECR, KMS AND S3) ON AWS..."
copilot env init                \
  --app hiperium-city-tasks     \
  --name "$TASK_SERVICE_ENV"   \
  --profile "$AWS_PROFILE"      \
  --region "$AWS_REGION"        \
  --default-config

echo ""
echo "DEPLOYING COPILOT ENVIRONMENT (VPC, SUBNETS AND ECS) ON AWS..."
copilot env deploy              \
  --app hiperium-city-tasks     \
  --name "$TASK_SERVICE_ENV"

echo ""
echo "DEPLOYING COPILOT ECS CLUSTER ON AWS..."
copilot deploy                  \
  --app hiperium-city-tasks     \
  --name api                    \
  --env "$TASK_SERVICE_ENV"

echo ""
echo "PUSHING CHANGES TO GIT REPOSITORY..."
git status
git add "$WORKING_DIR"/copilot/api/manifest.yml
git commit -m "Updating Copilot manifest.yml file with the latest automation scripts changes."
git push --set-upstream origin "$TASK_SERVICE_ENV"

echo ""
echo "DONE!"
