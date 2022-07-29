#!/usr/bin/env bash

PROJECT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
GIT_BRANCH=$SCRUTINIZER_BRANCH

# Creating tag and github release.
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
  https://api.github.com/repos/whirlplatform/whirl/releases \
  -d '{"tag_name":"'"$PROJECT_VERSION"'","target_commitish":"'"$GIT_BRANCH"'","name":"'"$PROJECT_VERSION"'","body":"Release '"$PROJECT_VERSION"'","draft":false,"prerelease":false,"generate_release_notes":false}'
