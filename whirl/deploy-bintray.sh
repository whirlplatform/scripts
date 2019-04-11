#!/usr/bin/env bash

cd ~/build/

PROJECT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
echo 'Project version: ' $PROJECT_VERSION

echo 'Bintray: Application deploying...'
curl -v -T ~/build/whirl-app/whirl-app-server/target/whirl-app-server-$PROJECT_VERSION.war -u$BINTRAY_USER:$BINTRAY_API_KEY https://api.bintray.com/content/whirlplatform/maven/whirl/$PROJECT_VERSION/whirl-app-$PROJECT_VERSION.war
echo 'Bintray: Application deploy completed'

echo 'Bintray: Editor deploying...'
curl -v -T ~/build/whirl-editor/whirl-editor-server/target/whirl-editor-server-$PROJECT_VERSION.war -u$BINTRAY_USER:$BINTRAY_API_KEY https://api.bintray.com/content/whirlplatform/maven/whirl/$PROJECT_VERSION/whirl-app-$PROJECT_VERSION.war
echo 'Bintray: Editor deploy completed'