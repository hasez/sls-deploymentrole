#!/usr/bin/env bash

set -u
set -e

Owner="rvp"
SystemCode="ifr"
Env="dev"
Use="cfn-service-role"

CFN_STACKNAME="${Owner}-${SystemCode}-${Env}-${Use}"
CFN_TEMPLATE="iam_cfn_service_role.yml"
CFN_PARAMETERS="iam_cfn_service_role.${Env}.properties"

CHANGESET_OPTION="--no-execute-changeset"

if [ $# = 1 ] && [ "$1" = "deploy" ]; then
  echo "deploy mode"
  CHANGESET_OPTION=""
fi
export AWS_REGION="us-east-1"
aws --profile "${AWS_PROFILE:-revamp}" cloudformation deploy \
    --stack-name "${CFN_STACKNAME}" \
    --template-file "${CFN_TEMPLATE}" \
    --parameter-overrides $(cat "${CFN_PARAMETERS}") \
    --capabilities CAPABILITY_NAMED_IAM \
    ${CHANGESET_OPTION}
