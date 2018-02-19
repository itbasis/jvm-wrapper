#!/usr/bin/env bash

CUR_DIR=$(dirname "$0")
source "${CUR_DIR}/_test_core.sh"

#
before_test
export USE_SYSTEM_JDK=N
export JVMW_DEBUG=Y

#
TEST_OUTPUT=$(./jdkw -fullversion 2>&1)
[[ "${TEST_OUTPUT}" == *"No program found to execute: -fullversion"* ]] || die
#
after_test