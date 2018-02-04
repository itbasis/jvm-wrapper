#!/usr/bin/env bash

OS=$(uname | tr '[:upper:]' '[:lower:]')
SYSTEM_JVM=9.0.4
# Hack for code verification
TEST_JDK_LAST_UPDATE_FILE=${TEST_JDK_LAST_UPDATE_FILE}
TEST_JAVA_HOME=${TEST_JAVA_HOME}
TEST_FULL_VERSION=${TEST_FULL_VERSION}
#

function before_test() {
	rm -Rf ./*
	cp ../jdkw ./
	cp "$1" ./jvmw.properties

	after_test

	while read -r line; do
		eval "export ${line}"
	done <<<"$(grep 'TEST_' jvmw.properties)"

	c=$(grep -v -e 'TEST_' -e '^#' jvmw.properties)
	echo "${c}" > jvmw.properties
	export USE_SYSTEM_JDK=N
}

function after_test() {
	unset USE_SYSTEM_JDK JVMW_DEBUG REQUIRED_UPDATE JVM_VERSION
	for env_test in $(env | grep TEST_); do
		unset "${env_test%%=*}"
	done
}

function test_execute_jvm_00() {
	rm -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}"
	rm -Rf "${HOME}/.jvm/${TEST_JAVA_HOME}"

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/${TEST_JAVA_HOME}"* ]] || return 10
	[[ "${TEST_OUTPUT}" != *"//"* ]] || return 20

	TEST_OUTPUT=$(./jdkw 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/${TEST_JAVA_HOME}"* ]] || return 10
	[[ "${TEST_OUTPUT}" != *"//"* ]] || return 20

	return 0
}

function test_execute_jvm_01() {
	rm -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}"
	rm -Rf "${HOME}/.jvm/${TEST_JAVA_HOME}"

	export JVMW_DEBUG=Y

	[[ ! -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 10
	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 20
	[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"/.jvm/${TEST_JDK_LAST_UPDATE_FILE}"* ]] || return 30
	# shellcheck disable=SC2143
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 40
	# shellcheck disable=SC2143
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || return 50
	# shellcheck disable=SC2143
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=")" ]] || return 60
	# shellcheck disable=SC2143
	[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || return 70

	[[ -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 80
	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 90
	[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"/.jvm/${TEST_JDK_LAST_UPDATE_FILE}"* ]] || return 100
	# shellcheck disable=SC2143
	[[ "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 110
	# shellcheck disable=SC2143
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || return 120
	[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || return 130

	return 0
}

function test_execute_jvm_02() {
	rm -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}"
	rm -Rf "${HOME}/.jvm/${TEST_JAVA_HOME}"

	export JVMW_DEBUG=Y
	export REQUIRED_UPDATE=N

	# shellcheck disable=SC2005
	fake_date=$([[ "${OS}" == "darwin" ]] && echo "$(date -v -2d +"%F %R")" || echo "$(date --date="-2 days" '+%F %R')")
	printf "%s" "${fake_date}" >"${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}"

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/.jvm/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 10
	# shellcheck disable=SC2143
	[[ "${TEST_OUTPUT}" == *"No such file or directory"* ]] || return 20
	# shellcheck disable=SC2143
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || return 30
	# shellcheck disable=SC2143
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 40
}

function test_execute_jdk_00() {
	mkdir -p ./test
	cp ../tests/Test.java ./test/

	[[ -f "test/Test.java" ]] || return 10;

	TEST_OUTPUT=$(./jdkw javac -d ./test test/Test.java 2>&1)
	[[ -f "test/Test.class" ]] || return 20;

	TEST_OUTPUT=$(./jdkw java -cp ./test/ Test 2>&1)
	[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || return 30
}

function test_execute_jdk_01() {
	cp -R ../tests/gradle/ ./

	TEST_OUTPUT=$(./jdkw gradlew clean build 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/${TEST_JAVA_HOME}"* ]] || return 10
	[[ -f "build/libs/test.jar" ]] || return 20;

	TEST_OUTPUT=$(./jdkw java -jar build/libs/test.jar 2>&1)
	[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || return 30
}

function test_execute_jdk_02() {
	cp -R ../tests/gradle/ ./

	TEST_OUTPUT=$(./jdkw ./gradlew clean build 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/${TEST_JAVA_HOME}"* ]] || return 10
	[[ -f "build/libs/test.jar" ]] || return 20;

	TEST_OUTPUT=$(./jdkw java -jar build/libs/test.jar 2>&1)
	[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || return 30
}

function test_execute_jdk_03() {
	mkdir -p ./test
	cp ../tests/Test.java ./test/

	TEST_OUTPUT=$(./jdkw ./javac -d ./test test/Test.java 2>&1)
	[[ -f "test/Test.class" ]] || return 10;

	TEST_OUTPUT=$(./jdkw java -cp ./test/ Test 2>&1)
	[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || return 20
}

function test_execute_system_jdk_00() {
	rm -Rf "${HOME}/.jvm/jdk${SYSTEM_JVM}"
	rm -f "${HOME}/.jvm/jdk${SYSTEM_JVM}.last_update"

	export USE_SYSTEM_JDK=Y

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" != *"/.jvm/${TEST_JAVA_HOME}"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || return 20

}

function test_execute_system_jdk_01() {
	rm -Rf "${HOME}/.jvm/jdk${SYSTEM_JVM}"
	rm -f "${HOME}/.jvm/jdk${SYSTEM_JVM}.last_update"

	export USE_SYSTEM_JDK=Y
	export JVMW_DEBUG=Y

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"USE_SYSTEM_JDK=Y"* ]] || return 10

	TEST_OUTPUT=$(./jdkw 2>&1)
	[[ "${TEST_OUTPUT}" == *"USE_SYSTEM_JDK=Y"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || return 20
}

function test_execute_system_jdk_02() {
	rm -Rf "${HOME}/.jvm/jdk${SYSTEM_JVM}"
	rm -f "${HOME}/.jvm/jdk${SYSTEM_JVM}.last_update"

	export USE_SYSTEM_JDK=N

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/${TEST_JAVA_HOME}"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "${TEST_OUTPUT}" == *"${TEST_FULL_VERSION}"* ]] || return 20
}

function test_execute_system_jdk_03() {
	rm -Rf "${HOME}/.jvm/jdk${SYSTEM_JVM}"
	rm -f "${HOME}/.jvm/jdk${SYSTEM_JVM}.last_update"

	export JVMW_DEBUG=Y
	export JVM_VERSION=7u80

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/jdk7u80"* ]] || return 10

	TEST_OUTPUT=$(./jdkw 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/jdk7u80"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "${TEST_OUTPUT}" == *"1.7.0_80"* ]] || return 20
}

function test_execute_system_jdk_04() {
	rm -Rf "${HOME}/.jvm/jdk${SYSTEM_JVM}"
	rm -f "${HOME}/.jvm/jdk${SYSTEM_JVM}.last_update"

	export JVMW_DEBUG=Y
	export JVM_VERSION=8u144

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/jdk8u144"* ]] || return 10

	TEST_OUTPUT=$(./jdkw 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/jdk8u144"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "${TEST_OUTPUT}" == *"1.8.0_144"* ]] || return 20
}

function test_execute_system_jdk_05() {
	rm -Rf "${HOME}/.jvm/jdk${SYSTEM_JVM}"
	rm -f "${HOME}/.jvm/jdk${SYSTEM_JVM}.last_update"

	export JVMW_DEBUG=Y
	export JVM_VERSION=9.0.1

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/jdk9.0.1"* ]] || return 10

	TEST_OUTPUT=$(./jdkw 2>&1)
	[[ "${TEST_OUTPUT}" == *"/.jvm/jdk9.0.1"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "${TEST_OUTPUT}" == *"9.0.1"* ]] || return 20
}

function run_test() {
	before_test "${1}"

	printf ":: execute '%s' from '%s'..." "${2}" "${1}"

	# shellcheck disable=SC2015
	${2} && {
		echo " OK";
		after_test;
	} || {
		echo " FAIL($?)";
		echo '----- TEST ENVIRONMENTS :: begin -----'
		env | grep TEST_
		echo '----- TEST ENVIRONMENTS :: end -----'
		echo '----- TEST CONFIGURATION FILE :: begin -----'
		cat jvmw.properties
		echo USE_SYSTEM_JDK=${USE_SYSTEM_JDK}
		echo JVMW_DEBUG=${JVMW_DEBUG}
		echo REQUIRED_UPDATE=${REQUIRED_UPDATE}
		echo '----- TEST CONFIGURATION FILE :: end -----'
		echo '----- OUTPUT :: begin -----'
		echo "${TEST_OUTPUT}"
		echo '----- OUTPUT :: end -----'
		after_test;
		exit 1;
	}
}

# shellcheck disable=SC2002
test_jvm_names="$(cat "$0" | awk 'match($0, /function test_execute_jvm_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"
# shellcheck disable=SC2002
test_jdk_names="$(cat "$0" | awk 'match($0, /function test_execute_jdk_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"
# shellcheck disable=SC2002
test_system_names="$(cat "$0" | awk 'match($0, /function test_execute_system_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"

rm -Rf ./build/* && mkdir -p ./build/ && cd ./build/

 test system jvm
if [[ "${OS}" == "darwin" ]]; then
	for test_suffix in ${test_system_names}; do
		run_test "../samples.properties/jvmw.${SYSTEM_JVM}.properties" "test_execute_${test_suffix}"
	done
fi

for p_file in $(find "../samples.properties" -mindepth 1 -maxdepth 1 -type f | sort -r); do
		for test_suffix in ${test_jvm_names}; do
			run_test "${p_file}" "test_execute_${test_suffix}"
		done
	for test_suffix in ${test_jdk_names}; do
		run_test "${p_file}" "test_execute_${test_suffix}"
	done
done

# clean
rm -Rf ./build/