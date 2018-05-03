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

function run_tests() {
	test_script="${1}"
	echo ":: execute '${test_script}'..."

	TMP_DIR=$(mktemp -d)
	echo "TMP_DIR=$TMP_DIR, ORIGIN_PWD=$ORIGIN_PWD"
	cd "${ORIGIN_PWD}" && ls -1 "$ORIGIN_PWD" | grep -v "build" | xargs -I find_src cp -R find_src "$TMP_DIR/"
	cd "$TMP_DIR" || exit 1
	#
	${test_script} || {
		rm -Rf "$TMP_DIR";
		exit 1; }
	rm -Rf "$TMP_DIR"
}

for test_script in $(find "$ORIGIN_PWD/src/test/bash" -name "${TEST_TYPE}.*.sh" -type f | sort); do
	run_tests "src/${test_script##*/src/}"
done

run_tests "./jdkw info"
