#!/bin/bash

echo ""
echo "UPDATING API GATEWAY ON AWS..."
aws cloudformation update-stack                                     \
  --stack-name hiperium-city-tasks-api-gw                           \
  --template-body file://utils/aws/cloudformation/ApiGateway.yml    \
  --parameters                                                      \
  ParameterKey=App,ParameterValue=hiperium-city-tasks               \
  ParameterKey=Env,ParameterValue="$TASK_SERVICE_ENV"               \
  ParameterKey=Name,ParameterValue=api                              \
  --capabilities CAPABILITY_NAMED_IAM
echo "DONE!"
