#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

# Hack for code verification
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
#
before_test
export USE_SYSTEM_JVM=N
#
mkdir -p ./test
cp "${PWD}/src/test/resources/Test.java" ./test/

[[ -f "test/Test.java" ]] || die;

TEST_OUTPUT=$(./jvmw javac -d ./test test/Test.java 2>&1)
[[ -f "test/Test.class" ]] || die;

TEST_OUTPUT=$(./jvmw java -cp ./test/ Test 2>&1)
[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || die
#
after_test
