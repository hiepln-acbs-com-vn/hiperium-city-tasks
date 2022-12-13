#!/bin/bash

cd "$WORKING_DIR"/src/hiperium-city-tasks-pwa/ || {
  echo "Error moving to the Tasks Service 'frontend' directory."
  exit 1
}

echo ""
if [ -z "$AWS_PROFILE" ]; then
  read -r -p 'Please, enter the <AWS profile> to deploy the resources on AWS: [profile default] ' aws_profile
  if [ -z "$aws_profile" ]; then
    AWS_PROFILE='default'
    export AWS_PROFILE
  else
    AWS_PROFILE=$aws_profile
    export AWS_PROFILE
  fi
fi

if [ -z "$AWS_REGION" ]; then
  read -r -p 'Please, enter the <AWS Region> ID used to deploy the resources on AWS: [default us-east-1] ' aws_region
  if [ -z "$aws_region" ]; then
    AWS_REGION='us-east-1'
    export AWS_REGION
  else
    AWS_REGION=$aws_region
    export AWS_REGION
  fi
fi

echo ""
echo "Updating the Ionic/Angular App to use the generated API Gateway..."
timer_service_api_id=$(aws cloudformation describe-stacks   \
  --stack-name hiperium-city-tasks-api-gw                   \
  --query "Stacks[0].Outputs[0].OutputValue"                \
  --output text                                             \
  --profile "$AWS_PROFILE")

# REPLACING the API Gateway URL in the environment.dev.ts file
sed -i'.bak' -e "s/timer_service_api_id/$timer_service_api_id/g; s/timer_service_api_region/$aws_region/g" src/environments/environment.dev.ts
echo "DONE!"

echo ""
echo "Building the Ionic/Angular App..."
npm run-script build

echo ""
echo "Deploying the Ionic/Angular App locally..."
http-server www -p 8100
