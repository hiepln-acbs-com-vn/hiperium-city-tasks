#!/bin/bash

WORKING_DIR=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
export WORKING_DIR

function setEnvironmentVariables() {
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
}

function validateEnvVars() {
  if [ -z "$AWS_PROFILE" ] || [ -z "$AWS_REGION" ] || [ -z "$TASK_SERVICE_VERSION" ] || [ -z "$TASK_SERVICE_BRANCH" ]; then
    setEnvironmentVariables
  fi
}
function validateStarCodeConn() {
  echo ""
  read -r -p 'Do you want to create a CodeStar Connection on AWS? [y/N]: ' yn
  if [ -z "$yn" ]; then
    yn='N'
  fi
  case $yn in
  [Yy]*)
    sh "$WORKING_DIR"/utils/scripts/helper/create-codestar-conn.sh
    ;;
  *)
    echo "Your answer: No."
    ;;
  esac
}

menu() {
  echo "
    *************************************
    ************* Main Menu *************
    *************************************
    b) Create CodeStar Connection.
    c) Create ALL resources.
    d) Delete ALL resources.
    -------------------------------------
    1) Create Backend.
    2) Create Backend CI/CD.
    3) Create Frontend.
    4) Create API Gateway.
    5) Create Frontend Hosting and CI/CD.
    6) Delete Backend.
    7) Delete Frontend.
    -------------------------------------
    q) QUIT.
  "
  read -r -p 'Choose an option: ' option
  case $option in
  [Bb])
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/helper/create-codestar-conn.sh
    menu
    ;;
  [Cc])
    validateEnvVars
    validateStarCodeConn
    sh "$WORKING_DIR"/utils/scripts/1_create-backend.sh
    sh "$WORKING_DIR"/utils/scripts/2_create-backend-cicd.sh
    sh "$WORKING_DIR"/utils/scripts/3_create-frontend.sh
    sh "$WORKING_DIR"/utils/scripts/4_create-api-gateway.sh
    echo ""
    echo "Please, wait a moment until the API Gateway finish its deployment..."
    sleep 60
    echo "DONE!"
    sh "$WORKING_DIR"/utils/scripts/5_create-frontend-hosting-and-cicd.sh
    menu
    ;;
  [Dd])
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/6_delete-backend.sh
    sh "$WORKING_DIR"/utils/scripts/7_delete-frontend.sh
    menu
    ;;
  1)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/1_create-backend.sh
    menu
    ;;
  2)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/2_create-backend-cicd.sh
    menu
    ;;
  3)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/3_create-frontend.sh
    menu
    ;;
  4)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/4_create-api-gateway.sh
    menu
    ;;
  5)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/5_create-frontend-hosting-and-cicd.sh
    menu
    ;;
  6)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/6_delete-backend.sh
    menu
    ;;
  7)
    validateEnvVars
    sh "$WORKING_DIR"/utils/scripts/7_delete-frontend.sh
    menu
    ;;
  [Qq])
    clear
    echo ""
    echo "Bye!"
    echo ""
    exit 0
    ;;
  *)
    clear
    echo -e 'Wrong option.'
    menu
    ;;
  esac
}

clear
menu
