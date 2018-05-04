#!/usr/bin/env bash

source "${PWD}/src/test/bash/_test_core.sh"

# Hack for code verification
TEST_JVM_VERSION=${TEST_JVM_VERSION:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
#
before_test
export USE_SYSTEM_JVM=N
export REQUIRED_UPDATE=N
export JVMW_DEBUG=Y

# shellcheck disable=SC2155
export TEST_OS=$(uname | tr '[:upper:]' '[:lower:]')
export TEST_JDK_LAST_UPDATE_FILE=${HOME}/.jvm/${TEST_JVM_VENDOR}-jdk-${TEST_JVM_VERSION}.last_update

# shellcheck disable=SC2005
fake_date=$([[ "${TEST_OS}" == "darwin" ]] && echo "$(date -v -2d +"%F %R")" || echo "$(date --date="-2 days" '+%F %R')")
printf "%s" "${fake_date}" >"${TEST_JDK_LAST_UPDATE_FILE}"

TEST_OUTPUT=$(./jvmw java -fullversion 2>&1)
[[ -f "${TEST_JDK_LAST_UPDATE_FILE}" ]] || die
# shellcheck disable=SC2143
[[ "${TEST_OUTPUT}" == *"No such file or directory"* ]] || die
# shellcheck disable=SC2143
[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || die
# shellcheck disable=SC2143
[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || die
#
after_test
