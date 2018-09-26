#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=11
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=11+28
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-11"
export TEST_JVM_VERSION_MAJOR=11
#
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=aa5fea6e2f009e63dd8a8d7f532104e6476195a49ee6dd0d2b11c64966d028cc
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn-pub/java/jdk/11+28/55eed80b163941c8885ad9298e6d786a/jdk-11_osx-x64_bin.dmg
#
export TEST_ARCHIVE_JVM_CHECKSUM_linux=246a0eba4927bf30180c573b73d55fc10e226c05b3236528c3a721dff3b50d32
export TEST_ARCHIVE_JVM_URL_linux=http://download.oracle.com/otn-pub/java/jdk/11+28/55eed80b163941c8885ad9298e6d786a/jdk-11_linux-x64_bin.tar.gz
#
export TEST_ARCHIVE_JVM_CHECKSUM_windows=d64b9d725f0ed096ae839ef8506deb3b6f509b2e3ee1f9b0792c5116623d4c9d
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn-pub/java/jdk/11+28/55eed80b163941c8885ad9298e6d786a/jdk-11_windows-x64_bin.zip
