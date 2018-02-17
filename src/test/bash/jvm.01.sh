#!/usr/bin/env bash

CUR_DIR=$(dirname "$0")
source "${CUR_DIR}/_test_core.sh"

# Hack for code verification
TEST_JVM_VERSION=${TEST_JVM_VERSION:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
#
before_test
export USE_SYSTEM_JDK=N
export JVMW_DEBUG=Y

export TEST_JDK_LAST_UPDATE_FILE=${HOME}/.jvm/jdk${TEST_JVM_VERSION}.last_update

#
[[ ! -f "${TEST_JDK_LAST_UPDATE_FILE}" ]] || die
TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
[[ -f "${TEST_JDK_LAST_UPDATE_FILE}" ]] || die
[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"${TEST_JDK_LAST_UPDATE_FILE}"* ]] || die
# shellcheck disable=SC2143
[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || die
# shellcheck disable=SC2143
[[ ! "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || die
# shellcheck disable=SC2143
[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=")" ]] || die
# shellcheck disable=SC2143
[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || die

#
[[ -f "${TEST_JDK_LAST_UPDATE_FILE}" ]] || die
TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
[[ -f "${TEST_JDK_LAST_UPDATE_FILE}" ]] || die
[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"${TEST_JDK_LAST_UPDATE_FILE}"* ]] || die
# shellcheck disable=SC2143
[[ "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || die
# shellcheck disable=SC2143
[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || die
[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || die
#
after_test