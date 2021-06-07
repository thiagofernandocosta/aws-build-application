#!/bin/bash

# Make sure you're not using another profile
unset AWS_PROFILE

# Change AWS values
export AWS_ACCOUNT_ID="MY_ACCOUNT_ID"
export AWS_ACCESS_KEY_ID="MY_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="MY_AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="eu-central-1"

# Application Config
APPLICATION_NAME="challenge-nextjs"
BRANCH="release"
COMMIT_SHA1="55f258e74516"
TAG=$BRANCH-$COMMIT_SHA1