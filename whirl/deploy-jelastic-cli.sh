
curl -s ftp://ftp.jelastic.com/pub/cli/jelastic-cli-installer.sh | bash

~/jelastic/users/authentication/signin --login $JELASTIC_LOGIN --password $JELASTIC_PASSWORD --platformUrl $JELASTIC_HOSTER_API --silent true
if [ $? -eq 0 ]
then
  echo 'Jelastic: Application deploying completed'
else
  echo 'FAIL: Jelastic deployment '
  exit 1
fi

echo 'Jelastic: Application deploying...'
~/jelastic/environment/deployment/deployarchive --envName whirl-demo --context ROOT --fileUrl https://github.com/whirlplatform/whirl/releases/download/v0.1.0/whirl-application-v0.1.0.war --fileName whirl-application-v0.1.0.war
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
