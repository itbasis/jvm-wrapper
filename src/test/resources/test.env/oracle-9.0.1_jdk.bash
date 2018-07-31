#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=9.0.1
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=9.0.1+11
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-9.0.1"
export TEST_JVM_VERSION_MAJOR=9
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=e87f9c83045f68546e78ee24a61724d06180581b0712ffdcdcac8faf6a3eca56
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn/java/jdk/9.0.1+11/jdk-9.0.1_osx-x64_bin.dmg
export TEST_ARCHIVE_JVM_CHECKSUM_linux=2cdaf0ff92d0829b510edd883a4ac8322c02f2fc1beae95d048b6716076bc014
export TEST_ARCHIVE_JVM_URL_linux=http://download.oracle.com/otn/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.tar.gz
export TEST_ARCHIVE_JVM_CHECKSUM_windows=4df5f74fe04c708977e23bdae8842297bce10d550e4a1cbedde9a33af56f4dab
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn/java/jdk/9.0.1+11/jdk-9.0.1_windows-x64_bin.exe
