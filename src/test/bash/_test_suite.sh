#!/usr/bin/env bash

ORIGIN_PWD=$PWD
# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}

# shellcheck disable=SC1090
source "$PWD/src/test/resources/test.env/$ENV_TEST_FILE.sh"

# Hack for code verification
TEST_TYPE=${TEST_TYPE:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
TEST_REUSE_JAVA_VERSION=${TEST_REUSE_JAVA_VERSION}
#


for test_script in $(find . -name "${TEST_TYPE}.*.sh" -type f | sort); do
	echo ":: execute '${test_script}'..."

	TMP_DIR=`mktemp -d`
	cp -R "$ORIGIN_PWD/" "$TMP_DIR/"
	cd "$TMP_DIR"

	${test_script} || {
	rm -Rf "$TMP_DIR";
	exit 1; }
	rm -Rf "$TMP_DIR"
done
