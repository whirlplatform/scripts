#!/usr/bin/env bash
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GITHUB_ACCESS_TOKEN" \
  https://api.github.com/repos/whirlplatform/whirl/releases \
  -d '{"tag_name":"'"$SCRUTINIZER_BRANCH"'","name":"'"$SCRUTINIZER_BRANCH"'","body":"Release version: '"$SCRUTINIZER_BRANCH"'","draft":false,"prerelease":false,"generate_release_notes":false}'