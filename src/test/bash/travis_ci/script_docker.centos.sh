#!/usr/bin/env bash

# Hack for code verification
DOCKER_IMAGE=${DOCKER_IMAGE:?}

# shellcheck disable=SC2086
docker run \
--rm \
-it \
-e ORACLE_USER \
-e ORACLE_PASSWORD \
-e ENV_TEST_FILE \
-v "${PWD}/":/root/jdkw-prj \
 ${DOCKER_IMAGE} bash -c "cd /root/jdkw-prj && ./src/test/bash/_test_suite.sh 2>&1"
