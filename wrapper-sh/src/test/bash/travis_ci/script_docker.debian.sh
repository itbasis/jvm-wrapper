#!/usr/bin/env bash

# Hack for code verification
DOCKER_IMAGE=${DOCKER_IMAGE:?}

# shellcheck disable=SC2086,SC2140
docker run \
--rm \
-it \
-e ORACLE_USER \
-e ORACLE_PASSWORD \
-e ENV_TEST_FILE \
-v "${PWD}/src":"/opt/jvmw-prj/src":ro \
-v "${PWD}/builder.bash":"/opt/jvmw-prj/builder.bash":ro \
-v "${PWD}/../samples.properties":/opt/jvmw-prj/samples.properties \
 ${DOCKER_IMAGE} bash -c "apt-get update && apt-get install -y curl wget xz-utils git && /opt/jvmw-prj/src/test/bash/docker_tests.sh"
