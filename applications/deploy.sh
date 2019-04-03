#!/usr/bin/env bash

echo 'Deploy started'
find . ! -path './.*' ! -path './scripts*' -type f -exec curl -v --user $JELASTIC_FTP_USER:$JELASTIC_FTP_PASSWORD --ftp-create-dirs -T {} ftp://$JELASTIC_TOMCAT_IP/$JELASTIC_APPLICATION_PATH/{} \;
echo 'Deploying complete'