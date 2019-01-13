#!/usr/bin/env bats

@test "check_checksum_JVM_LESS_8" {
	export JVM_VERSION_MAJOR=7

	load ../../main/bash/core

	run check_checksum
	[[ "$status" -eq 0 ]]
}

@test "check_checksum_JVM_8" {
	export JVM_VERSION_MAJOR=8
	export ARCHIVE_FILE="./src/test/resources/Test.java"
	export ARCHIVE_JVM_CHECKSUM=e349b9956e2ce5046579bc9fc7a125ed6ba309d3fcf39a95d1bf4a5ac32b9285

	load ../../main/bash/core

	run check_checksum
	[[ "$status" -eq 0 ]]

	export ARCHIVE_JVM_CHECKSUM=e349b9956e2ce5046579bc9fc7a125ed6ba309d3fcf39a95d1bf4a5ac32b9286
	run check_checksum
	[[ "$status" -eq 1 ]]
}

@test "JVMW_HOME default" {
	load ../../main/bash/core

	echo "JVMW_HOME=${JVMW_HOME}"
	[[ "$JVMW_HOME" == "$HOME/.jvm" ]]
}

@test "JVMW_HOME custom" {
	export JVMW_HOME=test
	load ../../main/bash/core

	echo "JVMW_HOME=${JVMW_HOME}"
	[[ "$JVMW_HOME" == "test" ]]
}
