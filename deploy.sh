#!/bin/bash -x
# Copy one repo to another. Useful for moving a wiki into place.

if [ "$TRAVIS_BRANCH" == "" ]; then
  echo "this only works with travis-ci"
  exit 1
fi

# This repo.
FROM="https://$GITHUB_API_KEY@github.com/unifi-poller/wiki.git"
# Test wiki
TO="https://$GITHUB_API_KEY@github.com/unifi-poller/wiki.wiki.git"
# Prod wiki
if [ "$TRAVIS_BRANCH" == "master" ]; then
  TO="https://$GITHUB_API_KEY@github.com/unifi-poller/unifi-poller.wiki.git"
fi


git config user.name "unifi-poller"
git config user.email "code@golift.io"

git remote remove origin
git remote add origin ${FROM} > /dev/null 2>&1
git remote add upstream ${TO} > /dev/null 2>&1
git fetch origin
git fetch upstream
git merge upstream/master --no-edit
# git push origin HEAD:master > /dev/null 2>&1
git push --force upstream HEAD:master > /dev/null 2>&1
