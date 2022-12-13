#!/bin/bash

echo ""
if [ -z "$AWS_PROFILE" ]; then
  read -r -p 'Please, enter the <AWS profile> to deploy the API on AWS: [profile default] ' aws_profile
  if [ -z "$aws_profile" ]; then
    AWS_PROFILE='default'
    export AWS_PROFILE
  else
    AWS_PROFILE=$aws_profile
    export AWS_PROFILE
  fi
fi

if [ -z "$TASK_SERVICE_ENV" ]; then
  read -r -p 'Please, enter the <Env> Name (aka Branch Name) used to deploy the resources on AWS: [default dev] ' app_env_name
  if [ -z "$app_env_name" ]; then
    TASK_SERVICE_ENV='dev'
    export TASK_SERVICE_ENV
  else
    TASK_SERVICE_ENV=$app_env_name
    export TASK_SERVICE_ENV
  fi
fi
git_actual_branch=$(git branch --show-current)
if [ "$git_actual_branch" != "$TASK_SERVICE_ENV" ]; then
  echo ""
  echo "ERROR: You are NOT on the '$TASK_SERVICE_ENV' branch. Please, move to the '$TASK_SERVICE_ENV' branch and try again."
  exit 0
fi

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

app_client_id_web=$(aws cloudformation describe-stacks  \
  --stack-name "$authStack"                             \
  --query "Stacks[0].Outputs[1].OutputValue"            \
  --output text                                         \
  --profile "$idp_profile_name")
if [ -z "$app_client_id_web" ]; then
  echo "No Cognito Client ID Web found on CloudFormation."
  exit 0
fi
echo "Cognito Client ID Web: $app_client_id_web"

echo ""
echo "UPDATING API GATEWAY ON AWS..."
aws cloudformation update-stack                                     \
  --stack-name hiperium-city-tasks-api-gw                           \
  --template-body file://../../aws/cloudformation/ApiGateway.yml    \
  --parameters                                                      \
  ParameterKey=App,ParameterValue=hiperium-city-tasks               \
  ParameterKey=Env,ParameterValue="$TASK_SERVICE_ENV"               \
  ParameterKey=Name,ParameterValue=api                              \
  ParameterKey=AppClientIDWeb,ParameterValue="$app_client_id_web"   \
  ParameterKey=UserPoolID,ParameterValue="$user_pool_id"            \
  --capabilities CAPABILITY_NAMED_IAM
