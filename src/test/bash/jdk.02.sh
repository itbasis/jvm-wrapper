#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

# Hack for code verification
TEST_JVM_HOME=${TEST_JVM_HOME:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
#
before_test
export USE_SYSTEM_JDK=N
export JVMW_DEBUG=N
#
cp -R ${PWD}/src/test/resources/gradle/* ./

TEST_OUTPUT=$(./jdkw ./gradlew clean build 2>&1)
[[ "${TEST_OUTPUT}" == *"${TEST_JVM_HOME}"* ]] || die
[[ -f "build/libs/test.jar" ]] || die;

TEST_OUTPUT=$(./jdkw java -jar build/libs/test.jar 2>&1)
[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || die
#
after_test
