#!/usr/bin/env bats

setup() {
	while IFS='' read -r line || [[ -n "$line" ]]; do
		eval "export $line"
	done < "src/test/resources/test.env/$ENV_TEST_FILE.properties"

	export JVM_VERSION=${TEST_JVM_VERSION}
	export JVM_VENDOR=${TEST_JVM_VENDOR}
	export JVMW_DEBUG=Y
	export USE_SYSTEM_JVM=N
	export JVMW_ORACLE_KEYCHAIN=JVM_WRAPPER_ORACLE
	export CLEAR_COOKIE=N

	echo '----------'
	env
	echo '----------'
}

@test "check jvm wrapper script" {
	run ./build/jvmw java -version
	echo "output: $output"

	[[ "$status" -eq 0 ]]
}
