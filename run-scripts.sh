#!/bin/bash

WORKING_DIR=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
export WORKING_DIR

function setEnvironmentVariables() {
  echo ""
  if [ -z "$AWS_PROFILE" ]; then
    read -r -p 'Please, enter the <AWS profile> for the service Workloads: [profile default] ' aws_profile
    if [ -z "$aws_profile" ]; then
      AWS_PROFILE='default'
      export AWS_PROFILE
    else
      AWS_PROFILE=$aws_profile
      export AWS_PROFILE
    fi
  fi

  if [ -z "$AWS_REGION" ]; then
    read -r -p 'Please, enter the <AWS Region> for the service Workloads: [default us-east-1] ' aws_region
    if [ -z "$aws_region" ]; then
      AWS_REGION='us-east-1'
      export AWS_REGION
    else
      AWS_REGION=$aws_region
      export AWS_REGION
    fi
  fi

  if [ -z "$TASK_SERVICE_ENV" ]; then
    read -r -p 'Please, enter the <Env Name> for the service Workloads: [default dev] ' tasks_env_name
    if [ -z "$tasks_env_name" ]; then
      TASK_SERVICE_ENV='dev'
      export TASK_SERVICE_ENV
    else
      TASK_SERVICE_ENV=$tasks_env_name
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

function setEnvironmentVariablesWithIdP() {
  setEnvironmentVariables
  if [ -z "$IDP_AWS_PROFILE" ]; then
    read -r -p 'Please, enter the <AWS IdP Profile> where the IdP Service is deployed: [default idp-pre] ' idp_profile_name
    if [ -z "$idp_profile_name" ]; then
      IDP_AWS_PROFILE='idp-pre'
      export IDP_AWS_PROFILE
    else
      IDP_AWS_PROFILE=$idp_profile_name
      export IDP_AWS_PROFILE
    fi
  fi
}

function verifyEnvVarsWithIdP() {
  if [ -z "$AWS_PROFILE" ] || [ -z "$AWS_REGION" ] || [ -z "$TASK_SERVICE_ENV" ] || [ -z "$IDP_AWS_PROFILE" ]; then
    clear
    setEnvironmentVariablesWithIdP
  fi
}

function verifyEnvVarsWithoutIdP() {
  if [ -z "$AWS_PROFILE" ] || [ -z "$AWS_REGION" ] || [ -z "$TASK_SERVICE_ENV" ]; then
    clear
    setEnvironmentVariables
  fi
}

helperMenu() {
  echo "
    *************************************
    ************ Helper Menu ************
    *************************************
    1) Update CodeBuild Config.
    2) Update Config files for Local Env.
    3) Revert Automated Files.
    -------------------------------------
    q) QUIT.
  "
  read -r -p 'Choose an option: ' option
  case $option in
  1)
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/helper/1_update-codebuild-project.sh
    helperMenu
    ;;
  2)
    verifyEnvVarsWithIdP
    sh "$WORKING_DIR"/utils/scripts/helper/2_update_config_for_local_env.sh
    helperMenu
    ;;
  3)
    clear
    sh "$WORKING_DIR"/utils/scripts/helper/3_revert-automated-files.sh
    helperMenu
    ;;
  [Qq])
    clear
    menu
    ;;
  *)
    clear
    echo -e 'Wrong option.'
    helperMenu
    ;;
  esac
}

menu() {
  echo "
    *************************************
    ************* Main Menu *************
    *************************************
    c) Create ALL resources.
    d) Delete ALL resources.
    h) Helper scripts.
    -------------------------------------
    1) Create CodeStar Connection.
    2) Create Backend.
    3) Create Backend CI/CD.
    4) Create Frontend.
    5) Create Frontend Hosting and CI/CD.
    6) Delete Frontend.
    7) Delete Backend.
    -------------------------------------
    q) QUIT.
  "
  read -r -p 'Choose an option: ' option
  case $option in
  [Cc])
    sh "$WORKING_DIR"/utils/scripts/1_create-codestar-conn.sh
    verifyEnvVarsWithIdP
    sh "$WORKING_DIR"/utils/scripts/2_create-backend.sh
    sh "$WORKING_DIR"/utils/scripts/3_create-backend-cicd.sh
    sh "$WORKING_DIR"/utils/scripts/4_create-frontend.sh
    sh "$WORKING_DIR"/utils/scripts/5_create-frontend-hosting-and-cicd.sh
    menu
    ;;
  [Dd])
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/6_delete-frontend.sh
    sh "$WORKING_DIR"/utils/scripts/7_delete-backend.sh
    menu
    ;;
  [Hh])
    clear
    helperMenu
    ;;
  1)
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/1_create-codestar-conn.sh
    menu
    ;;
  2)
    verifyEnvVarsWithIdP
    sh "$WORKING_DIR"/utils/scripts/2_create-backend.sh
    menu
    ;;
  3)
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/3_create-backend-cicd.sh
    menu
    ;;
  4)
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/4_create-frontend.sh
    menu
    ;;
  5)
    verifyEnvVarsWithIdP
    sh "$WORKING_DIR"/utils/scripts/5_create-frontend-hosting-and-cicd.sh
    menu
    ;;
  6)
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/6_delete-frontend.sh
    menu
    ;;
  7)
    verifyEnvVarsWithoutIdP
    sh "$WORKING_DIR"/utils/scripts/7_delete-backend.sh
    menu
    ;;
  [Qq])
    clear
    echo ""
    echo "Done!"
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
