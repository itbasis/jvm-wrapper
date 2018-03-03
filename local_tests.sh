#!/usr/bin/env bash

chmod +x ./src/test/bash/*.sh
shellcheck -e SC1090 -x src/test/bash/*.sh local_tests.sh

# shellcheck disable=SC2034
export DOCKER_IMAGES='centos:centos6 centos:centos7 debian:wheezy debian:jessie ubuntu:trusty opensuse:latest base/arch:latest'

for DOCKER_IMAGE in ${DOCKER_IMAGES}; do
	docker pull "${DOCKER_IMAGE}"
done

while read -r line; do
	eval "export ${line}"
done < "${HOME}/.jvm/jvmw.properties"

function run_test() {
	export TEST_TYPE=$1
	export TEST_JVM_VENDOR=$2
	export TEST_JVM_VERSION=$3
	export TEST_FULL_VERSION=$4
	export TEST_REUSE_JVM_VERSION=$5
	export TEST_JVM_TYPE=$6
#	export TEST_USE_SYSTEM=$7
	export TEST_USE_SYSTEM=N
	export TEST_JVMW_FILE_PROPERTIES=./samples.properties/jvmw.${TEST_JVM_VERSION}.properties

	./src/test/bash/_test_suite.sh || exit $?
}

run_test 'jvm' 'oracle' '9' '9.0.4+11' '9.0.4' 'jdk' Y
run_test 'jvm' 'oracle' '9.0.4' '9.0.4+11' '' 'jdk' Y
run_test 'jvm' 'oracle' '9.0.1' '9.0.1+11' '' 'jdk'
run_test 'jvm' 'oracle' '8' '1.8.0_161-b12' '8u161' 'jdk'
run_test 'jvm' 'oracle' '8u161' '1.8.0_161-b12' '' 'jdk'
run_test 'jvm' 'oracle' '8u162' '1.8.0_162-b12' '' 'jdk'
run_test 'jvm' 'oracle' '8u144' '1.8.0_144-b01' '' 'jdk'
#run_test 'jvm' 'oracle' '7' '1.7.0_80-b15' '' 'jdk'
run_test 'jvm' 'oracle' '7u80' '1.7.0_80-b15' '' 'jdk'

run_test 'jdk' 'oracle' '9' '9.0.4+11' '9.0.4' 'jdk' Y
run_test 'jdk' 'oracle' '9.0.4' '9.0.4+11' '' 'jdk' Y
run_test 'jdk' 'oracle' '9.0.1' '9.0.1+11' '' 'jdk'
run_test 'jdk' 'oracle' '8' '1.8.0_161-b12' '8u161' 'jdk'
run_test 'jdk' 'oracle' '8u161' '1.8.0_161-b12' '' 'jdk'
run_test 'jdk' 'oracle' '8u162' '1.8.0_162-b12' '' 'jdk'
run_test 'jdk' 'oracle' '8u144' '1.8.0_144-b01' '' 'jdk'
#run_test 'jdk' 'oracle' '7' '1.7.0_80-b15' '' 'jdk'
run_test 'jdk' 'oracle' '7u80' '1.7.0_80-b15' '' 'jdk'

#
rm -Rf ./build/