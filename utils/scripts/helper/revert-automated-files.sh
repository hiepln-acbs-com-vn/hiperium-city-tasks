#!/bin/bash

currentDir=${PWD##*/}
if [ "$currentDir" != "hiperium-city-tasks" ]; then
  echo "Please, run this script from the 'hiperium-city-tasks' root directory."
  exit 1
fi

echo ""
echo "REVERTING API MANIFEST FILE..."
cat utils/scripts/templates/copilot/manifest-arm64 > copilot/api/manifest.yml

echo "REVERTING API GATEWAY CLOUDFORMATION FILE..."
cat utils/scripts/templates/aws/ApiGateway > utils/aws/cloudformation/ApiGateway.yml

echo "REVERTING IONIC ENVIRONMENT CONFIG FILES..."
cat utils/scripts/templates/ionic/ionic-environment-dev  > src/hiperium-city-tasks-pwa/src/environments/environment.dev.ts
cat utils/scripts/templates/ionic/ionic-environment-test > src/hiperium-city-tasks-pwa/src/environments/environment.test.ts
cat utils/scripts/templates/ionic/ionic-environment-prod > src/hiperium-city-tasks-pwa/src/environments/environment.prod.ts

echo ""
echo "DONE!"
echo ""


