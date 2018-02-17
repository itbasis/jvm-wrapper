#!/usr/bin/env bash

CUR_DIR=$(dirname "$0")
source "${CUR_DIR}/_test_core.sh"

# Hack for code verification
TEST_JVM_HOME=${TEST_JVM_HOME:?}
TEST_JVM_VERSION=${TEST_JVM_VERSION:?}
TEST_REUSE_JVM_VERSION=${TEST_REUSE_JVM_VERSION}
#
if [[ -z "${TEST_REUSE_JVM_VERSION}" ]]; then
	exit
fi
#
before_test
export USE_SYSTEM_JDK=N
export JVMW_DEBUG=Y

#
TEST_OUTPUT=$(./jdkw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die

./jdkw java -fullversion 2>&1

export JVM_VERSION=${TEST_REUSE_JVM_VERSION}

TEST_OUTPUT=$(./jdkw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die
#
after_test