#!/bin/bash

cd "$WORKING_DIR"/ || {
  echo "Error moving to the Tasks Service 'root' directory."
  exit 1
}

read -r -p 'Please, enter your <Git Provider> name to deploy on AWS: [default GitHub] ' git_provider
if [ -z "$git_provider" ]; then
  git_provider='GitHub'
fi

echo ""
echo "CREATING A CODESTAR CONNECTION ON AWS..."
aws codestar-connections create-connection  \
  --provider-type $git_provider             \
  --connection-name hiperium-city-tasks

echo ""
echo "Please, go to the 'Connections Settings' in the 'Developer Tools' console and complete the connection process."
echo "After that, return to this terminal window and press any key to continue..."
read -n 1 -s -r -p ""

echo ""
echo "DONE!"
