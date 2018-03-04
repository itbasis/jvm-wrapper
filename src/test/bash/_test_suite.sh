#!/usr/bin/env bash

# Hack for code verification
TEST_TYPE=${TEST_TYPE:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
TEST_REUSE_JAVA_VERSION=${TEST_REUSE_JAVA_VERSION}
#

rm -Rf ./build/
mkdir -p ./build/
cd ./build/ || exit 1

CUR_DIR=./../$(dirname "$0")
export CUR_DIR

for test_script in $(find "${CUR_DIR}" -name "${TEST_TYPE}.*.sh" -type f -maxdepth 1 -mindepth 1 | sort); do
	echo ":: execute '${test_script}'..."
	${test_script} || exit 1
done