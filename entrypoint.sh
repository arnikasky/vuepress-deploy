#!/bin/bash

set -e

echo ''

# env
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"

# Build vuepress project
echo "==> Start building \n $BUILD_SCRIPT"
eval "$BUILD_SCRIPT"
echo "Build success"

# Change directory to the dest
echo "==> Changing directory to '$BUILD_DIR' ..."
cd $BUILD_DIR

echo "$(pwd)"

git config --global --add safe.directory "*"

# Get respository
if [[ -z "$TARGET_REPO" ]]; then
  REPOSITORY_NAME="${GITHUB_REPOSITORY}"
else
  REPOSITORY_NAME="$TARGET_REPO"
fi

# Get branch
if [[ -z "$TARGET_BRANCH" ]]; then
  DEPLOY_BRAN="gh-pages"
else
  DEPLOY_BRAN="$TARGET_BRANCH"
fi

# Final repository
DEPLOY_REPO="https://username:${ACCESS_TOKEN}@github.com/${REPOSITORY_NAME}.git"
if [ "$TARGET_LINK" ]; then
  DEPLOY_REPO="$TARGET_LINK"
fi

echo "==> Prepare to deploy"

# git config --global --add safe.directory "/github/workspace/docs/.vuepress/dist/"

git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

if [ -z "$(git status --porcelain)" ]; then
    echo "The BUILD_DIR is setting error or nothing produced" && \
    echo "Exiting..."
    exit 0
fi
