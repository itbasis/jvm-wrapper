#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

#
before_test
export USE_SYSTEM_JDK=N
export JVMW_DEBUG=Y

#
TEST_OUTPUT=$(./jdkw -fullversion 2>&1)
[[ "${TEST_OUTPUT}" == *"No program found to execute: -fullversion"* ]] || die
#
after_test
