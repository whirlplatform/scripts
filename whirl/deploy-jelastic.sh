#!/usr/bin/env bash

echo 'Jelastic: Application deploying...'
cd ~/build/whirl-app/whirl-app-server && mvn jelastic:deploy -P deploy-jelastic -Djelastic.hoster_api=$JELASTIC_HOSTER_API -Djelastic.login=$JELASTIC_LOGIN -Djelastic.password=$JELASTIC_PASSWORD -Djelastic.environment=$JELASTIC_ENVIRONMENT  -Djelastic.context=$JELASTIC_CONTEXT_APP
if [ $? -eq 0 ]
then
  echo 'Jelastic: Application deploying completed'
else
  echo 'FAIL: Jelastic deployment '
  exit 1
fi

echo 'Jelastic: Editor deploying...'
cd ~/build/whirl-editor/whirl-editor-server && mvn jelastic:deploy -P deploy-jelastic -Djelastic.hoster_api=$JELASTIC_HOSTER_API -Djelastic.login=$JELASTIC_LOGIN -Djelastic.password=$JELASTIC_PASSWORD -Djelastic.environment=$JELASTIC_ENVIRONMENT  -Djelastic.context=$JELASTIC_CONTEXT_EDITOR
if [ $? -eq 0 ]
then
  echo 'Jelastic: Editor deploying completed'
else
  echo 'FAIL: Jelastic deployment '
  exit 1
fi
