#!/usr/bin/env bash

# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}
DOCKER_IMAGE=${DOCKER_IMAGE:?}
#

DOCKER_TAG=${DOCKER_IMAGE%%:*}
DOCKER_TAG=${DOCKER_TAG%%/*}

DOCKER_SCRIPT=${PWD}/src/test/bash/travis_ci/script_docker.${DOCKER_TAG}.sh

export DOCKER_IMAGE
echo ":: :: execute '${DOCKER_SCRIPT}'..."
${DOCKER_SCRIPT} || exit 1
