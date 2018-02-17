#!/usr/bin/env bash

CUR_DIR=$(dirname "$0")
source "${CUR_DIR}/_test_core.sh"

# Hack for code verification
TEST_JVM_HOME=${TEST_JVM_HOME:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
TEST_USE_SYSTEM=${TEST_USE_SYSTEM}
#
if [[ -z "${TEST_USE_SYSTEM}" ]]; then
	exit
fi
#
before_test
export USE_SYSTEM_JDK=Y
export JVMW_DEBUG=N

#
TEST_OUTPUT=$(./jdkw info 2>&1)
[[ "${TEST_OUTPUT}" != *"${TEST_JVM_HOME}"* ]] || die

TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || die
#
after_test