#!/bin/bash

cd "$WORKING_DIR"/src/hiperium-city-tasks-pwa/ || {
  echo "Error moving to the Tasks Service 'frontend' directory."
  exit 1
}

echo ""
echo "INSTALLING NODEJS DEPENDENCIES FOR THE IONIC/ANGULAR APP..."
npm install

echo ""
echo "INITIALIZING THE AMPLIFY PROJECT ON AWS..."
amplify init

echo ""
echo "PUSHING RECENT CHANGES TO GIT REPOSITORY..."
git status
git add .
git commit -m "Initializing Amplify configuration on AWS."
git push --set-upstream origin "$TASK_SERVICE_ENV"

echo ""
echo "DONE!"
