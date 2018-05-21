#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=10
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=10.0.1+10
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-10/"
