#!/usr/bin/env bats

setup() {
	export JVMW_DEBUG=Y
	export JVM_VERSION_MAJOR=${TEST_JVM_VERSION_MAJOR}
	export JVMW_ORACLE_KEYCHAIN=JVM_WRAPPER_ORACLE
	export CLEAR_COOKIE=N

	while IFS='' read -r line || [[ -n "$line" ]]; do
		eval "export $line"
	done < "src/test/resources/test.env/$ENV_TEST_FILE.properties"

	load ../../../main/bash/jvmw/core
	load ../../../main/bash/jvmw/download
	load ../../../main/bash/jvmw/download_oracle
	load ../../../main/bash/jvmw/download_openjdk
	load ../../../main/bash/jvmw/unpack
}

@test "download JDK ${TEST_JVM_VERSION}" {
	export ARCHIVE_JVM_CHECKSUM=`printenv "TEST_ARCHIVE_JVM_CHECKSUM_${OS}"`
	export ARCHIVE_JVM_URL=`printenv "TEST_ARCHIVE_JVM_URL_${OS}"`
	export ARCHIVE_FILE=$BATS_TMPDIR/jdk${TEST_JVM_VERSION}.${ARCHIVE_EXT}

	echo "ARCHIVE_FILE=$ARCHIVE_FILE"
	#run rm -f "${ARCHIVE_FILE}"
	run download_jdk
	echo "output: $output"

	[[ "$status" -eq 0 ]]
}
