#!/usr/bin/env bash
# This script deploys the application and editor to the Jelastic cloud from github.com release page:
# https://github.com/whirlplatform/whirl/releases
#
# Environment variables:
#   JELASTIC_HOSTER_API - Jelastic hoster API URL
#   JELASTIC_LOGIN - Jelastic user name
#   JELASTIC_PASSWORD - Jelastic password
#   TAG - version of the application to deploy
#   ENV_PREFIX - prefix of the environment name
#   ENV_TYPE - type of the environment to deploy to. Possible values: demo, develop
#   ENV_CONTEXT - context on the server to deploy to

JELASTIC_ENVIRONMENT="${ENV_PREFIX}-${ENV_TYPE}"

if [ -z "$ENV_CONTEXT" ]
then
  ENV_CONTEXT_APP=ROOT
  ENV_CONTEXT_EDITOR=editor
else
  ENV_CONTEXT_APP=$ENV_CONTEXT
  ENV_CONTEXT_EDITOR=$ENV_CONTEXT-editor
fi

curl -s ftp://ftp.jelastic.com/pub/cli/jelastic-cli-installer.sh | bash

~/jelastic/users/authentication/signin --login $JELASTIC_LOGIN --password $JELASTIC_PASSWORD --platformUrl $JELASTIC_HOSTER_API --silent true
if [ $? -ne 0 ]; then
  echo "Jelastic: Failed to sign in"
  exit 1
fi

echo 'Jelastic: Application deploying...'
~/jelastic/environment/deployment/deployarchive --envName ${JELASTIC_ENVIRONMENT} --context ${ENV_CONTEXT_APP} --fileUrl "https://github.com/whirlplatform/whirl/releases/download/${TAG}/whirl-application-${TAG}.war" --fileName whirl-application-${TAG}.war
if [ $? -eq 0 ]
then
  echo 'Jelastic: Application deployment completed'
else
  echo 'FAIL: Deployment of application to Jelastic'
  exit 1
fi

echo 'Jelastic: Editor deploying...'
~/jelastic/environment/deployment/deployarchive --envName ${JELASTIC_ENVIRONMENT} --context ${ENV_CONTEXT_EDITOR} --fileUrl "https://github.com/whirlplatform/whirl/releases/download/${TAG}/whirl-editor-${TAG}.war" --fileName whirl-editor-${TAG}.war
if [ $? -eq 0 ]
then
  echo 'Jelastic: Editor deployment completed'
else
  echo 'FAIL: Deployment of editor to Jelastic'
  exit 1
fi
