#!/usr/bin/env bash

test_failure() {
	rm -Rf ./build/ ./jvmw.properties
	echo "----"
	echo "test failure: ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[0]}"
	# shellcheck disable=SC2016
	echo '$ ls ${HOME}/.jvm/'
	ls -lAFh "${HOME}/.jvm/"
	exit 1
}

mkdir -p ./build/

CHECK_JDK_VERSION='1.8.0' CHECK_JDK_HOME='jdk8' JDK_FAMILY='8' ./tests.sh || test_failure
CHECK_JDK_VERSION='1.8.0_151' CHECK_JDK_HOME='jdk8' JDK_FAMILY='8' ./tests.sh || test_failure
CHECK_JDK_VERSION='1.8.0_152' CHECK_JDK_HOME='jdk8u152' JDK_FAMILY='8' JDK_UPDATE_VERSION=152 ./tests.sh || test_failure
CHECK_JDK_VERSION='1.8.0' CHECK_JDK_HOME='jdk8' JVMW_FILE='jvmw.8.properties' ./tests.sh || test_failure
CHECK_JDK_VERSION='1.8.0_151' CHECK_JDK_HOME='jdk8' JVMW_FILE='jvmw.8.properties' ./tests.sh || test_failure
CHECK_JDK_VERSION='1.8.0_152' CHECK_JDK_HOME='jdk8u152' JVMW_FILE='jvmw.8u152.properties' ./tests.sh || test_failure

CHECK_JDK_VERSION='9.0.1' CHECK_JDK_HOME='jdk9' ./tests.sh || test_failure
CHECK_JDK_VERSION='9.0.1' CHECK_JDK_HOME='jdk9' JDK_FAMILY='9' ./tests.sh || test_failure
CHECK_JDK_VERSION='9.0.1' CHECK_JDK_HOME='jdk9' JVMW_FILE='jvmw.9.properties' ./tests.sh || test_failure
CHECK_JDK_VERSION='9.0.1' CHECK_JDK_HOME='jdk9u152' JVMW_FILE='incorrect.jvmw.9u152.properties' ./tests.sh 2> /dev/null && test_failure

rm -Rf ./build/* && cp ./jdkw ./build/jdkw
CHECK_JDK_VERSION='1.8.0' CHECK_JDK_HOME='jdk8' JDK_FAMILY='8' ./tests.sh ./build/jdkw || test_failure
rm -Rf ./build/* && cp ./jdkw ./build/jdkw
CHECK_JDK_VERSION='1.8.0' CHECK_JDK_HOME='jdk8' JVMW_FILE='jvmw.8.properties' ./tests.sh ./build/jdkw || test_failure

rm -Rf ./build/