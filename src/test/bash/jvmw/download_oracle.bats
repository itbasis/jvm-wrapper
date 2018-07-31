#!/usr/bin/env bats

setup() {
	export JVMW_DEBUG=Y
	export JVM_VERSION_MAJOR=${TEST_JVM_VERSION_MAJOR}
	export JVMW_ORACLE_KEYCHAIN=JVM_WRAPPER_ORACLE
	export CLEAR_COOKIE=N

	load ../../resources/test.env/$ENV_TEST_FILE

	load ../../../main/bash/jvmw/core
	load ../../../main/bash/jvmw/download_oracle
}

@test "download JDK ${TEST_JVM_VERSION}" {
	export ARCHIVE_JVM_CHECKSUM=`printenv "TEST_ARCHIVE_JVM_CHECKSUM_${OS}"`
	export ARCHIVE_JVM_URL=`printenv "TEST_ARCHIVE_JVM_URL_${OS}"`
	export ARCHIVE_FILE=$BATS_TMPDIR/jdk${TEST_JVM_VERSION}.${ARCHIVE_EXT}

	echo "ARCHIVE_FILE=$ARCHIVE_FILE"
	run rm -f "${ARCHIVE_FILE}"
	run oracle_download_jdk
	echo "output: $output"
	[[ "$status" -eq 0 ]]
}
