#!/bin/bash

cd "$WORKING_DIR" || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

echo ""
echo "REVERTING TASKS API FROM COPILOT MANIFEST FILE..."
cat utils/scripts/templates/copilot/manifest-arm64 > copilot/api/manifest.yml

echo "REVERTING IONIC ENVIRONMENT CONFIG FILES..."
cat utils/scripts/templates/ionic/ionic-environment-local  > src/hiperium-city-tasks-pwa/src/environments/environment.ts
cat utils/scripts/templates/ionic/ionic-environment-dev  > src/hiperium-city-tasks-pwa/src/environments/environment.dev.ts
cat utils/scripts/templates/ionic/ionic-environment-test > src/hiperium-city-tasks-pwa/src/environments/environment.test.ts
cat utils/scripts/templates/ionic/ionic-environment-prod > src/hiperium-city-tasks-pwa/src/environments/environment.prod.ts

echo "REVERTING DOCKER-COMPOSE ENVIRONMENT FILE..."
cat utils/scripts/templates/docker/env > utils/docker/compose/dev.env

echo ""
echo "DONE!"
echo ""


