#!/usr/bin/env bash

export TEST_JVM_VENDOR=oracle
export TEST_JVM_VERSION=8u144
export TEST_TYPE=jvm
export TEST_JVM_TYPE=jdk
export TEST_FULL_VERSION=1.8.0_144-b01
# shellcheck disable=SC2034
export TEST_JVM_HOME="${HOME}/.jvm/oracle-jdk-8u144"
export TEST_JVM_VERSION_MAJOR=8
#
export TEST_ARCHIVE_JVM_CHECKSUM_darwin=2450b35e10295ccf3fb1596bdea6f8f5670f7200ae3ac592eb6a54cc030cf94b
export TEST_ARCHIVE_JVM_URL_darwin=http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-macosx-x64.dmg
#
export TEST_ARCHIVE_JVM_CHECKSUM_linux=e8a341ce566f32c3d06f6d0f0eeea9a0f434f538d22af949ae58bc86f2eeaae4
export TEST_ARCHIVE_JVM_URL_linux=http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
#
export TEST_ARCHIVE_JVM_CHECKSUM_windows=be9f6e920f817757ce1913c9c3f0a5d63046c720f37a95e4a14450a179f48a18
export TEST_ARCHIVE_JVM_URL_windows=http://download.oracle.com/otn/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-windows-x64.exe
