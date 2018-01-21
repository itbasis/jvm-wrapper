#!/usr/bin/env bash

cleanup() {
	rm -Rf ./build/ ./jvmw.properties ./tmp/
}

test_failure() {
	cleanup
	echo "----"
	echo "test failure: ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[0]}"
	# shellcheck disable=SC2016
	echo '$ ls ${HOME}/.jvm/'
	ls -lAFh "${HOME}/.jvm/"
	exit 1
}

run() {
	echo "${@:1}"
	eval "${@:1}"
}

run CHECK_JDK_VERSION='1.8.0' CHECK_JDK_ROOT_DIR='jdk8' JDK_VERSION_MAJOR='8' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_161' CHECK_JDK_ROOT_DIR='jdk8' JDK_VERSION_MAJOR='8' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_162' CHECK_JDK_ROOT_DIR='jdk8u162' JDK_VERSION_MAJOR='8' JDK_VERSION_MINOR='162' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0' CHECK_JDK_ROOT_DIR='jdk8' JVMW_FILE='jvmw.8_a.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0' CHECK_JDK_ROOT_DIR='jdk8' JVMW_FILE='jvmw.8_b.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_161' CHECK_JDK_ROOT_DIR='jdk8' JVMW_FILE='jvmw.8_a.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_161' CHECK_JDK_ROOT_DIR='jdk8' JVMW_FILE='jvmw.8_b.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_162' CHECK_JDK_ROOT_DIR='jdk8u162' JVMW_FILE='jvmw.8u162.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_152' CHECK_JDK_ROOT_DIR='jdk8u152' JDK_VERSION_MAJOR='8' JDK_VERSION_MINOR='152' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_152' CHECK_JDK_ROOT_DIR='jdk8u152' JDK_VERSION='8u152' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_144' CHECK_JDK_ROOT_DIR='jdk8u144' JVMW_FILE='jvmw.8u144_a.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_144' CHECK_JDK_ROOT_DIR='jdk8u144' JVMW_FILE='jvmw.8u144_b.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='1.8.0_144' CHECK_JDK_ROOT_DIR='jdk8u144' JVMW_FILE='jvmw.8u144_c.properties' ./tests.sh || test_failure

run CHECK_JDK_VERSION='9.0.4' CHECK_JDK_ROOT_DIR='jdk9' ./tests.sh || test_failure
run CHECK_JDK_VERSION='9.0.4' CHECK_JDK_ROOT_DIR='jdk9' JDK_VERSION_MAJOR='9' ./tests.sh || test_failure
#run CHECK_JDK_VERSION='9.0.1' CHECK_JDK_ROOT_DIR='jdk9.0.1' JDK_VERSION_MAJOR='9' JDK_VERSION_MINOR=1 ./tests.sh || test_failure
#run CHECK_JDK_VERSION='9.0.4' CHECK_JDK_ROOT_DIR='jdk9.0.4' JDK_VERSION_MAJOR='9' JDK_VERSION_MINOR=4 ./tests.sh || test_failure
run CHECK_JDK_VERSION='9.0.4' CHECK_JDK_ROOT_DIR='jdk9' JVMW_FILE='jvmw.9.properties' ./tests.sh || test_failure
run CHECK_JDK_VERSION='9.0.4' CHECK_JDK_ROOT_DIR='jdk9u152' JVMW_FILE='incorrect.jvmw.9u152.properties' ./tests.sh 2>/dev/null && test_failure

run CHECK_JDK_VERSION='1.7.0_80' CHECK_JDK_ROOT_DIR='jdk7u80' JVMW_FILE='jvmw.7u80.properties' ./tests.sh || test_failure

cleanup && mkdir -p ./tmp/ && cp ./jdkw ./tmp/jdkw
run CHECK_JDK_VERSION='1.8.0' CHECK_JDK_ROOT_DIR='jdk8' JDK_VERSION_MAJOR='8' ./tests.sh ./tmp/jdkw || test_failure
cleanup && mkdir -p ./tmp/ && cp ./jdkw ./tmp/jdkw
run CHECK_JDK_VERSION='1.8.0' CHECK_JDK_ROOT_DIR='jdk8' JVMW_FILE='jvmw.8_a.properties' ./tests.sh ./tmp/jdkw || test_failure

cleanup