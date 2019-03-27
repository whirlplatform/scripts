#!/usr/bin/env bash

echo 'Deploy started'
scp -r . ftp://jelastic-ftp:$JELASTIC_FTP_PASSWORD@$JELASTIC_TOMCAT_IP:$JELASTIC_APPLICATION_PATH
echo 'Deploying complete'