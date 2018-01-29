#!/usr/bin/env bash

OS=$(uname | tr '[:upper:]' '[:lower:]')
SYSTEM_JVM=9.0.4
# Hack for code verification
TEST_JDK_LAST_UPDATE_FILE=${TEST_JDK_LAST_UPDATE_FILE}
TEST_JAVA_HOME=${TEST_JAVA_HOME}
TEST_FULL_VERSION=${TEST_FULL_VERSION}
#

function before_test() {
	local -r env_test="$(grep 'TEST_' jvmw.properties)"
	if [[ ! -z "${env_test}" ]]; then
		while read -r line
		do
			eval "export ${line}"
		done <<<"${env_test}"
	fi
	c=$(grep -v -e 'TEST_' -e '^#' jvmw.properties)
	echo "${c}" > jvmw.properties

	rm -f "${HOME:?}/${TEST_JDK_LAST_UPDATE_FILE}"

	return 0
}

function after_test() {
	for env_test in $(env | grep TEST_); do
		unset "${env_test%%=*}"
	done
}

function test_execute_jvm_00() {
	echo -e "\\nUSE_SYSTEM_JDK=N" >> jvmw.properties

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"${TEST_JAVA_HOME}"* ]] || return 10
	[[ "${TEST_OUTPUT}" != *"//"* ]] || return 20

	return 0
}

function test_execute_jvm_01() {
	rm -Rf "${HOME:?}/${TEST_JAVA_HOME}"
	echo -e "\\nJVMW_DEBUG=Y" >> jvmw.properties
	echo -e "\\nUSE_SYSTEM_JDK=N" >> jvmw.properties

	[[ ! -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 10
	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 20
	[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"${TEST_JDK_LAST_UPDATE_FILE}"* ]] || return 30
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 40
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || return 50
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=")" ]] || return 60
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 70

	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 80
	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 90
	[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"${TEST_JDK_LAST_UPDATE_FILE}"* ]] || return 100
	[[ "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 110
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || return 120
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 130

	return 0
}

function test_execute_jvm_02() {
	rm -Rf ${HOME}/${TEST_JAVA_HOME}
	echo -e "\\nJVMW_DEBUG=Y" >> jvmw.properties
	echo -e "\\nREQUIRED_UPDATE=N" >> jvmw.properties
	echo -e "\\nUSE_SYSTEM_JDK=N" >> jvmw.properties

	fake_date=$([[ "${OS}" == "darwin" ]] && echo "$(date -v -2d +"%F %R")" || echo "$(date --date="-2 days" '+%F %R')")
	printf "%s" "${fake_date}" >"${HOME}/${TEST_JDK_LAST_UPDATE_FILE}"

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 10
	[[ "${TEST_OUTPUT}" == *"No such file or directory"* ]] || return 20
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JVM_URL=$")" ]] || return 30
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 40
}

function test_execute_jdk_00() {
	cp ../test/Test.java ./test/

	TEST_OUTPUT=$(./jdkw javac -d ./test test/Test.java 2>&1)
	[[ -f "test/Test.class" ]] || return 10

	TEST_OUTPUT=$(./jdkw java -cp ./test/ Test 2>&1)
	[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || return 20
}

function test_execute_system_jdk_00() {
	rm -Rf ${HOME}/jdk${SYSTEM_JVM}

	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" != *"${TEST_JAVA_HOME}"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 20
}

function test_execute_system_jdk_01() {
	rm -Rf ${HOME}/jdk${SYSTEM_JVM}

	echo -e "\\nJVMW_DEBUG=Y" >> jvmw.properties
	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"USE_SYSTEM_JDK=Y"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 20
}

function test_execute_system_jdk_02() {
	rm -Rf ${HOME}/jdk${SYSTEM_JVM}

	echo -e "\\nUSE_SYSTEM_JDK=N" >> jvmw.properties
	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"${TEST_JAVA_HOME}"* ]] || return 10

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 20
}

function run_test() {
	cp -f "${1}" jvmw.properties

	printf ":: execute '%s' from '%s'..." "${2}" "${1}"

	before_test

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
		echo '----- TEST CONFIGURATION FILE :: end -----'
		echo '----- OUTPUT :: begin -----'
		echo "${TEST_OUTPUT}"
		echo '----- OUTPUT :: end -----'
		after_test;
		exit 1;
	}
}

test_jvm_names="$(cat "$0" | awk 'match($0, /function test_execute_jvm_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"
test_jdk_names="$(cat "$0" | awk 'match($0, /function test_execute_jdk_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"
test_system_names="$(cat "$0" | awk 'match($0, /function test_execute_system_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"

rm -Rf ./build/*
mkdir -p ./build/test && cd ./build/ && cp ../jdkw ./
for p_file in $(find "../samples.properties" -mindepth 1 -maxdepth 1 -type f | sort -r); do
	for test_suffix in ${test_jvm_names}; do
		run_test "${p_file}" "test_execute_${test_suffix}"
	done
	for test_suffix in ${test_jdk_names}; do
		run_test "${p_file}" "test_execute_${test_suffix}"
	done
done

# test system jvm
if [[ "${OS}" == "darwin" ]]; then
	for test_suffix in ${test_system_names}; do
		run_test "../samples.properties/jvmw.${SYSTEM_JVM}.properties" "test_execute_${test_suffix}"
	done
fi

# clean
rm -Rf ./build/