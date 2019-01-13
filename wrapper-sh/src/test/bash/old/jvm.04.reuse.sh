#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

# Hack for code verification
TEST_JVM_TYPE=${TEST_JVM_TYPE:?}
TEST_JVM_HOME=${TEST_JVM_HOME:?}
TEST_JVM_VERSION=${TEST_JVM_VERSION:?}
TEST_JVM_VENDOR=${TEST_JVM_VENDOR:?}
TEST_REUSE_JVM_VERSION=${TEST_REUSE_JVM_VERSION}
#
if [[ -z "${TEST_REUSE_JVM_VERSION}" ]]; then
	exit
fi
#
before_test
export USE_SYSTEM_JVM=N
export JVMW_DEBUG=N

#
TEST_OUTPUT=$(./jvmw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die

./jvmw info 2>&1
./jvmw java -fullversion 2>&1

export JVM_VERSION=${TEST_REUSE_JVM_VERSION}

TEST_OUTPUT=$(./jvmw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die
export TEST_JVM_HOME="${HOME}/.jvm/${TEST_JVM_VENDOR}-${TEST_JVM_TYPE}-${TEST_REUSE_JVM_VERSION}/"
[[ "${TEST_OUTPUT}" != *"${TEST_JVM_HOME}"* ]] || die
#
after_test
