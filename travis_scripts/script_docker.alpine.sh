#!/usr/bin/env bash

# shellcheck disable=SC2086
docker run \
--rm \
-it \
-e "ORACLE_USER=${ORACLE_USER}" \
-e "ORACLE_PASSWORD=${ORACLE_PASSWORD}" \
-v "$(pwd)/jdkw":/root/jdkw \
-v "$(pwd)/test/":/root/test/ \
-v "$(pwd)/samples/":/root/samples/ \
-v "$(pwd)/test_suite.sh":/root/test_suite.sh \
-v "$(pwd)/tests.sh":/root/tests.sh \
-v "$(pwd)/tmp.volume":/root/.jvm \
 $DOCKER_IMAGE:$DOCKER_TAG sh -c "apk add --update --no-cache curl bash && cd /root && ./test_suite.sh 2>&1"