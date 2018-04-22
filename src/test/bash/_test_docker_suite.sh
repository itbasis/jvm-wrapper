#!/usr/bin/env bash

# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}
#TEST_TYPE=${TEST_TYPE:?}
#TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
#TEST_REUSE_JAVA_VERSION=${TEST_REUSE_JAVA_VERSION}
DOCKER_IMAGES=${DOCKER_IMAGES:?}
#

rm -Rf ./build/
mkdir -p ./build/
cd ./build/ || exit 1

CUR_DIR=./../$(dirname "$0")
export CUR_DIR

for DOCKER_IMAGE in ${DOCKER_IMAGES}; do
	docker_image=${DOCKER_IMAGE%%:*}
	docker_image=${docker_image%%/*}
	docker_script=${CUR_DIR}/travis_ci/script_docker.${docker_image}.sh
	export DOCKER_IMAGE
	echo ":: :: execute '${docker_script}'..."
	${docker_script} || exit 1
	echo ":: :: done..."
done
