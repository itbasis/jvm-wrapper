#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

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
export USE_SYSTEM_JVM=N
export JVMW_DEBUG=N

#
TEST_OUTPUT=$(./jvmw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die

TEST_OUTPUT=$(./jvmw java -fullversion 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || die
#
after_test
