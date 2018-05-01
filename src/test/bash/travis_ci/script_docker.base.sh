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
 ${DOCKER_IMAGE} bash -c "export HOME=/root/jdkw-prj && cd /root/jdkw-prj && ./jdkw ./gradlew test && ./src/test/bash/_test_suite.sh 2>&1"
