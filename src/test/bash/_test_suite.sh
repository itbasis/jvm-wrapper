#!/usr/bin/env bash

# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}

# shellcheck disable=SC1090
source "src/test/resources/test.env/$ENV_TEST_FILE.sh"

# Hack for code verification
TEST_TYPE=${TEST_TYPE:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
TEST_REUSE_JAVA_VERSION=${TEST_REUSE_JAVA_VERSION}
#

rm -Rf ./build/
mkdir -p ./build/
cd ./build/ || exit 1

for test_script in $(find "../src/test/bash" -maxdepth 1 -mindepth 1 -name "${TEST_TYPE}.*.sh" -type f | sort); do
	echo ":: execute '${test_script}'..."
	${test_script} || exit 1
done