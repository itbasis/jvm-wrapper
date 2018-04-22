#!/usr/bin/env bash

# Hack for code verification
DOCKER_IMAGE=${DOCKER_IMAGE:?}

CUR_DIR=$(cd "$(dirname "$0")/../../../../" && pwd)

# shellcheck disable=SC2086
docker run \
--rm \
-it \
-e ORACLE_USER \
-e ORACLE_PASSWORD \
-e ENV_TEST_FILE \
-v "${CUR_DIR}/jdkw":/root/jdkw \
-v "${CUR_DIR}/src/":/root/src/ \
-v "${CUR_DIR}/samples.properties/":/root/samples.properties/ \
 ${DOCKER_IMAGE} bash -c "apt-get update && apt-get install -y curl && cd /root && ./src/test/bash/_test_suite.sh 2>&1"