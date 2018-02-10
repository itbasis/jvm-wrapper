#!/usr/bin/env bash

JVM_VERSION="9 9.0.4 9.0.1 8"
JVM_VERSION_ACTUAL_8=8u161
JVM_VERSION_ACTUAL_9=9.0.4

function run_test() {
	export JVM_VERSION=$1
	export TEST_FULL_VERSION=$2
	export TEST_REUSE_JAVA_VERSION=$3
	export JVMW_FILE_PROPERTIES=./samples.properties/jvmw.$1.properties

	./tests.sh || exit $?
}

run_test '9' '9.0.4+11' '9.0.4'
run_test '9.0.4' '9.0.4+11' ''
run_test '9.0.1' '9.0.1+11' ''
run_test '8' '1.8.0_161-b12' '8u161'
run_test '8u161' '1.8.0_161-b12' ''
run_test '8u162' '1.8.0_162-b12' ''
run_test '8u144' '1.8.0_144-b01' ''
run_test '7u80' '1.7.0_80-b15' ''
#for jv in ${JVM_VERSION}; do
#	echo "JVM_VERSION=${jv}"
#	echo "JVM_VERSION_ACTUAL=${JVM_VERSION_ACTUAL_8}"
#done

#for p_file in $(find "./samples.properties" -mindepth 1 -maxdepth 1 -type f | sort -r); do
#	echo "p_file = ${p_file}"
#done