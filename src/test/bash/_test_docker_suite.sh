#!/usr/bin/env bash

# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}
DOCKER_IMAGES=${DOCKER_IMAGES:?}
#

for DOCKER_IMAGE in ${DOCKER_IMAGES}; do
	docker_image=${DOCKER_IMAGE%%:*}
	docker_image=${docker_image%%/*}
	docker_script=${PWD}/src/test/bash/travis_ci/script_docker.${docker_image}.sh
	export DOCKER_IMAGE
	echo ":: DOCKER_IMAGE=${DOCKER_IMAGE}"
	echo ":: :: execute '${docker_script}'..."
	${docker_script} || exit 1
	echo ":: :: done..."
done
