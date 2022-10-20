#!/usr/bin/env bash
# This script deploys the application and editor to the Jelastic cloud with Jelastic Maven plugin.
# Script deploys the application and editor using project's packaged war files.
#
# Environment variables:
#   JELASTIC_HOSTER_API - Jelastic hoster API URL
#   JELASTIC_LOGIN - Jelastic user name
#   JELASTIC_PASSWORD - Jelastic password
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

echo 'Jelastic: Application deploying...'
cd ~/build/whirl-app/whirl-app-server && mvn jelastic:deploy -P deploy-jelastic -Djelastic.hoster_api=$JELASTIC_HOSTER_API -Djelastic.login=$JELASTIC_LOGIN -Djelastic.password=$JELASTIC_PASSWORD -Djelastic.environment=$JELASTIC_ENVIRONMENT -Djelastic.context=${ENV_CONTEXT_APP}
if [ $? -eq 0 ]
then
  echo 'Jelastic: Application deployment completed'
else
  echo 'FAIL: Deployment of application to Jelastic'
  exit 1
fi

echo 'Jelastic: Editor deploying...'
cd ~/build/whirl-editor/whirl-editor-server && mvn jelastic:deploy -P deploy-jelastic -Djelastic.hoster_api=$JELASTIC_HOSTER_API -Djelastic.login=$JELASTIC_LOGIN -Djelastic.password=$JELASTIC_PASSWORD -Djelastic.environment=$JELASTIC_ENVIRONMENT  -Djelastic.context=${ENV_CONTEXT_EDITOR}
if [ $? -eq 0 ]
then
  echo 'Jelastic: Editor deployment completed'
else
  echo 'FAIL: Deployment of editor to Jelastic'
  exit 1
fi
