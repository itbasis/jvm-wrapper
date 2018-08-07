#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=9.0.4
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=9.0.4+11
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-9"
export TEST_JVM_VERSION_MAJOR=9
#
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=f5c827ab4c3cf380827199005a3dfe8077a38c4d6e8b3fa37ec19ce6ca9aa658
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_osx-x64_bin.dmg
#
export TEST_ARCHIVE_JVM_CHECKSUM_linux=90c4ea877e816e3440862cfa36341bc87d05373d53389ec0f2d54d4e8c95daa2
export TEST_ARCHIVE_JVM_URL_linux=http://download.oracle.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz
#
export TEST_ARCHIVE_JVM_CHECKSUM_windows=56c67197a8f2f7723ffb0324191151075cdec0f0891861e36f3fadda28d556c3
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_windows-x64_bin.exe
