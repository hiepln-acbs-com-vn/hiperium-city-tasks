#!/bin/bash

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

user_pool_id=$(aws cloudformation describe-stacks   \
  --stack-name "$authStack"                         \
  --query "Stacks[0].Outputs[0].OutputValue"        \
  --output text                                     \
  --profile "$idp_profile_name")
if [ -z "$user_pool_id" ]; then
  echo "No Cognito User Pool found on CloudFormation."
  exit 0
fi
echo "Cognito User Pool ID: $user_pool_id"

app_client_id_web=$(aws cloudformation describe-stacks      \
  --stack-name "$authStack"                                 \
  --query "Stacks[0].Outputs[1].OutputValue"                \
  --output text                                             \
  --profile "$idp_profile_name")
if [ -z "$app_client_id_web" ]; then
  echo "No Cognito Client ID Web found on CloudFormation."
  exit 0
fi
echo "Cognito Client ID Web: $app_client_id_web"

amplify_app_id=$(aws amplify list-apps --query "apps[?name=='HiperiumCityTasksPWA'].appId" --output text)
if [ -z "$amplify_app_id" ]; then
  echo "No Amplify project ID found on CloudFormation."
  exit 0
fi
echo "Amplify Project ID: $amplify_app_id"

amplify_app_host_id=$TASK_SERVICE_ENV.$amplify_app_id
echo "Amplify App Host ID: $amplify_app_host_id"

echo ""
echo "UPDATING API GATEWAY CF FILE..."
sed -e "s/amplify_app_host_id/$amplify_app_host_id/g" utils/scripts/templates/aws/ApiGateway > utils/aws/cloudformation/ApiGateway.yml
echo "DONE!"

echo ""
echo "CREATING API GATEWAY ON AWS..."
aws cloudformation create-stack                                       \
  --stack-name hiperium-city-tasks-api-gw                             \
  --template-body file://utils/aws/cloudformation/ApiGateway.yml      \
  --parameters                                                        \
    ParameterKey=App,ParameterValue=hiperium-city-tasks               \
    ParameterKey=Env,ParameterValue="$TASK_SERVICE_ENV"               \
    ParameterKey=Name,ParameterValue=api                              \
    ParameterKey=AppClientIDWeb,ParameterValue="$app_client_id_web"   \
    ParameterKey=UserPoolID,ParameterValue="$user_pool_id"            \
  --capabilities CAPABILITY_NAMED_IAM

# Restore the ApiGateway.yml file to its original state.
git restore utils/aws/cloudformation/ApiGateway.yml
echo "DONE!"
