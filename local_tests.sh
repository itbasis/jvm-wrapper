#!/usr/bin/env bash

chmod +x ./src/test/bash/*.sh
shellcheck -e SC1090 -x src/test/bash/*.sh local_tests.sh

# shellcheck disable=SC2034
DOCKER_IMAGE='centos:centos6 centos:centos7 debian:wheezy debian:jessie ubuntu:trusty opensuse:latest base/arch:latest'

function run_test() {
	export TEST_TYPE=$1
	export TEST_JVM_VERSION=$2
	export TEST_FULL_VERSION=$3
	export TEST_REUSE_JAVA_VERSION=$4
	export TEST_JVM_TYPE=$5
	export TEST_JVMW_FILE_PROPERTIES=./samples.properties/jvmw.${TEST_JVM_VERSION}.properties

	./src/test/bash/_test_suite.sh || exit $?
}

#run_test 'jvm' '9' '9.0.4+11' '9.0.4' 'jdk'
#run_test 'jvm' '9.0.4' '9.0.4+11' '' 'jdk'
#run_test 'jvm' '9.0.1' '9.0.1+11' '' 'jdk'
#run_test 'jvm' '8' '1.8.0_161-b12' '8u161' 'jdk'
#run_test 'jvm' '8u161' '1.8.0_161-b12' '' 'jdk'
#run_test 'jvm' '8u162' '1.8.0_162-b12' '' 'jdk'
#run_test 'jvm' '8u144' '1.8.0_144-b01' '' 'jdk'
#run_test 'jvm' '7' '1.7.0_80-b15' '' 'jdk'
#run_test 'jvm' '7u80' '1.7.0_80-b15' '' 'jdk'

run_test 'jdk' '9' '9.0.4+11' '9.0.4' 'jdk'

#
rm -Rf ./build/