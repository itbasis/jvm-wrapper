#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=8
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=1.8.0_181-b13
export TEST_REUSE_JAVA_VERSION=8u181
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-8"
export TEST_JVM_VERSION_MAJOR=8
#
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=3ea78e0107f855b47a55414fadaabd04b94e406050d615663d54200ec85efc9b
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-macosx-x64.dmg
#
export TEST_ARCHIVE_JVM_CHECKSUM_linux=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz
export TEST_ARCHIVE_JVM_URL_linux=1845567095bfbfebd42ed0d09397939796d05456290fb20a83c476ba09f991d3
#
export TEST_ARCHIVE_JVM_CHECKSUM_windows=6d1e254081d56fa460505d5b0f10ce1e33426c44dfbcab838c2be620f35997a4
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-windows-x64.exe
