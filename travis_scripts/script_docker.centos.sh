#!/usr/bin/env bash

docker run \
--rm \
-it \
-v "$(pwd)/jdkw":/root/jdkw \
-v "$(pwd)/test/":/root/test/ \
-v "$(pwd)/samples/":/root/samples/ \
-v "$(pwd)/test_suite.sh":/root/test_suite.sh \
-v "$(pwd)/tests.sh":/root/tests.sh \
-v "$(pwd)/tmp.volume":/root/.jvm \
 $DOCKER_IMAGE:$DOCKER_TAG bash -c "cd /root && ./test_suite.sh 2>&1"