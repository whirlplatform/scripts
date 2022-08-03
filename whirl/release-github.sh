#!/usr/bin/env bash

# create a new release
# user: user's name
# repo: the repo's name
# token: github api user token
# tag: name of the tag pushed
create_release() {
    user=$1
    repo=$2
    token=$3
    tag=$4
    branch=$5

    command="curl -s -o release.json -w '%{http_code}' \
         --request POST \
         --header 'authorization: Bearer ${token}' \
         --header 'content-type: application/json' \
         --data '{\"tag_name\": \"'${tag}'\", \"target_commitish\": \"'${branch}'\", \"name\": \"'${tag}'\", \"body\": \"Release of '${tag}'\", \"draft\": false, \"prerelease\": false}' \
         https://api.github.com/repos/$user/$repo/releases"
    http_code=`eval $command`
    if [ $http_code == "201" ]; then
        echo "created release:"
        cat release.json
    else
        echo "create release failed with code '$http_code':"
        cat release.json
        exit 1
    fi
}

# upload a release file.
# this must be called only after a successful create_release, as create_release saves
# the json response in release.json.
# token: github api user token
# file: path to the asset file to upload
# name: name to use for the uploaded asset
upload_release_file() {
    token=$1
    file=$2
    name=$3

    url=`jq -r .upload_url release.json | cut -d{ -f'1'`
    command="\
      curl -s -o upload-${name}.json -w '%{http_code}' \
           --request POST \
           --header 'authorization: Bearer ${token}' \
           --header 'Content-Type: application/octet-stream' \
           --data-binary @\"${file}\"
           ${url}?name=${name}"
    http_code=`eval $command`
    if [ $http_code == "201" ]; then
        echo "asset $name uploaded:"
        jq -r .browser_download_url "upload-$name.json"
    else
        echo "upload failed with code '$http_code':"
        cat "upload-$name.json"
        exit 1
    fi
}

cd ~/build/

# get repository name and owner
GITHUB_REPO_REMOTE=$(git config --get remote.origin.url)
# owner from git@ like or https:// like ursl
GITHUB_REPO_OWNER=$(grep -oP '(?<=github.com/).*(?=/)' <<< $GITHUB_REPO_REMOTE ; if [ -z $? ]; then $1; else grep -oP ':\K.*?(?=/)' <<< $GITHUB_REPO_REMOTE; fi)
GITHUB_REPO_NAME=$(basename -s .git $GITHUB_REPO_REMOTE)

# get project version
TAG="v$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)"

create_release $GITHUB_REPO_OWNER $GITHUB_REPO_NAME $GITHUB_ACCESS_TOKEN $TAG $SCRUTINIZER_BRANCH

APPLICATION_WAR_NAME="$(cd whirl-app/whirl-app-server; mvn help:evaluate -Dexpression=project.build.finalName -q -DforceStdout).war"
APPLICATION_FILE="$(cd whirl-app/whirl-app-server; mvn help:evaluate -Dexpression=project.build.directory -q -DforceStdout)/$APPLICATION_WAR_NAME"
upload_release_file $GITHUB_ACCESS_TOKEN $APPLICATION_FILE "whirl-application-${TAG}.war"

EDITOR_WAR_NAME="$(cd whirl-editor/whirl-editor-server; mvn help:evaluate -Dexpression=project.build.finalName -q -DforceStdout).war"
EDITOR_FILE="$(cd whirl-editor/whirl-editor-server; mvn help:evaluate -Dexpression=project.build.directory -q -DforceStdout)/$EDITOR_WAR_NAME"
upload_release_file $GITHUB_ACCESS_TOKEN $EDITOR_FILE "whirl-editor-${TAG}.war"
