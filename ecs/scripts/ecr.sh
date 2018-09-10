#!/usr/bin/env bash


# config

set -e

ECS_REGION="us-east-2"
NAMESPACE="microservicemovies"
IMAGE_BASE="movies"
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${ECS_REGION}.amazonaws.com"
SHORT_GIT_HASH=$(echo $CIRCLE_SHA1 | cut -c -7)
TAG=$SHORT_GIT_HASH


# helpers

configure_aws_cli() {
  echo "Configuring AWS..."
  aws --version
  aws configure set default.region $ECS_REGION
  aws configure set default.output json
  echo "AWS configured!"
}

tag_and_push_images() {
  echo "Tagging and pushing images..."
  $(aws ecr get-login --region "${ECS_REGION}")
  # tag
  docker tag ${NAMESPACE}_${IMAGE_BASE} ${ECR_URI}/${NAMESPACE}_${IMAGE_BASE}:${TAG}
  # push
  docker push ${ECR_URI}/${NAMESPACE}_${IMAGE_BASE}:${TAG}
  echo "Images tagged and pushed!"
}

# main

configure_aws_cli
tag_and_push_images
