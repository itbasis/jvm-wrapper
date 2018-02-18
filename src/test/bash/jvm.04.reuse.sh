#!/usr/bin/env bash

CUR_DIR=$(dirname "$0")
source "${CUR_DIR}/_test_core.sh"

# Hack for code verification
TEST_JVM_TYPE=${TEST_JVM_TYPE:?}
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
export JVMW_DEBUG=N

#
TEST_OUTPUT=$(./jdkw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die

./jdkw info 2>&1
./jdkw java -fullversion 2>&1

export JVM_VERSION=${TEST_REUSE_JVM_VERSION}

TEST_OUTPUT=$(./jdkw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die
export TEST_JVM_HOME="${HOME}/.jvm/${TEST_JVM_TYPE}${TEST_REUSE_JVM_VERSION}/"
[[ "${TEST_OUTPUT}" != *"${TEST_JVM_HOME}"* ]] || die
#
after_test