#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=8u171
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=1.8.0_171-b11
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-8u171"
export TEST_JVM_VERSION_MAJOR=8
#
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=00ccc048009e64e7e341d55d35c8519ab63ef5f86f0d73d4e823281d0b358d40
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-macosx-x64.dmg
#
export TEST_ARCHIVE_JVM_CHECKSUM_linux=b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982
export TEST_ARCHIVE_JVM_URL_linux=http://download.oracle.com/otn/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz
#
export TEST_ARCHIVE_JVM_CHECKSUM_windows=841b20e904b7f46fe7c8ce88bd35148e9663c750c8336286d0eb05a0a5b203f4
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-windows-x64.exe
