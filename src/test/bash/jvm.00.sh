#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

# Hack for code verification
TEST_JVM_HOME=${TEST_JVM_HOME:?}
TEST_JVM_VERSION=${TEST_JVM_VERSION:?}
#
before_test
export USE_SYSTEM_JDK=N
#
TEST_OUTPUT=$(./jdkw info 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die
[[ "${TEST_OUTPUT}" != *"//"* ]] || die
#
TEST_OUTPUT=$(./jdkw 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die
[[ "${TEST_OUTPUT}" != *"//"* ]] || die
#
after_test
