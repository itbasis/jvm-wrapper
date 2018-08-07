#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=10
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=10.0.2+13
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-10"
export TEST_JVM_VERSION_MAJOR=10
#
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=2db323c9c93e7fb63e2ed7e06ce8150c32d782e3d0704be6274ebb2d298193aa
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_osx-x64_bin.dmg
#
export TEST_ARCHIVE_JVM_CHECKSUM_linux=6633c20d53c50c20835364d0f3e172e0cbbce78fff81867488f22a6298fa372b
export TEST_ARCHIVE_JVM_URL_linux=http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.tar.gz
#
export TEST_ARCHIVE_JVM_CHECKSUM_windows=bd2aa173db14789ac0369ab32bf929679760cae9e04d751d5f914ac3ad36c129
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_windows-x64_bin.exe
