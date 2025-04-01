#!/bin/bash

# Stop on errors, print commands
set -ex

# Arguments passed from Jenkinsfile
REPO_URL="$1"
DEPLOY_DIR="$2"
BRANCH_NAME="$3"

echo "Ensuring directory structure and code checkout..."
echo "Repository URL: ${REPO_URL}"
echo "Deployment Directory: ${DEPLOY_DIR}"
echo "Target Branch: ${BRANCH_NAME}"

# Create parent directory if it doesn't exist
mkdir -p "$(dirname "$DEPLOY_DIR")"

# Check if deploy directory exists and is a git repo
if [ ! -d "${DEPLOY_DIR}/.git" ]; then
  echo "Directory ${DEPLOY_DIR} not found or not a git repo. Cloning..."
  # Remove if exists but isn't a repo (safety)
  rm -rf "${DEPLOY_DIR}"
  git clone "${REPO_URL}" "${DEPLOY_DIR}"
  cd "${DEPLOY_DIR}"
  echo "Checking out branch ${BRANCH_NAME}..."
  git checkout "${BRANCH_NAME}"
else
  echo "Repository found in ${DEPLOY_DIR}. Force resetting and pulling updates for branch ${BRANCH_NAME}..."
  cd "${DEPLOY_DIR}"
  echo "Checking out branch ${BRANCH_NAME}..."
  git checkout "${BRANCH_NAME}"
  echo "Fetching latest changes from origin..."
  git fetch origin
  echo "Resetting local state to match origin/${BRANCH_NAME}..."
  git reset --hard "origin/${BRANCH_NAME}"
  echo "Pulling latest changes (should be up-to-date)..."
  git pull origin "${BRANCH_NAME}"
  echo "Cleaning untracked files..."
  git clean -fdx
fi

echo "Checkout/Update complete."