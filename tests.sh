#!/usr/bin/env bash

OS=$(uname | tr '[:upper:]' '[:lower:]')
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

function test_execute_00() {
	TEST_OUTPUT=$(./jdkw info 2>&1)
	[[ "${TEST_OUTPUT}" == *"${TEST_JAVA_HOME}"* ]] || return 10
	[[ "${TEST_OUTPUT}" != *"//"* ]] || return 20

	return 0
}

function test_execute_01() {
	rm -Rf "${HOME:?}/${TEST_JAVA_HOME}"
	echo -e "\\nJVMW_DEBUG=Y" >> jvmw.properties

	[[ ! -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 10
	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 20
	[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"${TEST_JDK_LAST_UPDATE_FILE}"* ]] || return 30
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 40
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JDK_URL=$")" ]] || return 50
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JDK_URL=")" ]] || return 60
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 70

	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 80
	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 90
	[[ "$(echo "${TEST_OUTPUT}" | grep 'LAST_UPDATE_FILE=')" == *"${TEST_JDK_LAST_UPDATE_FILE}"* ]] || return 100
	[[ "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 110
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JDK_URL=$")" ]] || return 120
	[[ "$(echo "${TEST_OUTPUT}")" == *"${TEST_FULL_VERSION}"* ]] || return 130

	return 0
}

function test_execute_02() {
	rm -Rf ${HOME}/${TEST_JAVA_HOME}
	echo -e "\nJVMW_DEBUG=Y\nREQUIRED_UPDATE=N" >> jvmw.properties

	fake_date=$([[ "${OS}" == "darwin" ]] && echo "$(date -v -2d +"%F %R")" || echo "$(date --date="-2 days" '+%F %R')")
	printf "%s" "${fake_date}" >"${HOME}/${TEST_JDK_LAST_UPDATE_FILE}"

	TEST_OUTPUT=$(./jdkw java -fullversion 2>&1)
	[[ -f "${HOME}/${TEST_JDK_LAST_UPDATE_FILE}" ]] || return 10
	[[ "${TEST_OUTPUT}" == *"No such file or directory"* ]] || return 20
	[[ "$(echo "${TEST_OUTPUT}" | grep "ARCHIVE_JDK_URL=$")" ]] || return 30
	[[ ! "$(echo "${TEST_OUTPUT}" | grep "prev_date=")" ]] || return 40
}

function test_execute_03() {
	cp ../test/Test.java ./test/

	TEST_OUTPUT=$(./jdkw javac -d ./test test/Test.java 2>&1)
	[[ -f "test/Test.class" ]] || return 10

	TEST_OUTPUT=$(./jdkw java -cp ./test/ Test 2>&1)
	[[ "${TEST_OUTPUT}" == "${TEST_FULL_VERSION}" ]] || return 20
}

test_names="$(cat "$0" | awk 'match($0, /function test_execute_([^(]+)/) { print substr($0, RSTART+22, RLENGTH-22) }')"

rm -Rf ./build/*
mkdir -p ./build/test && cd ./build/ && cp ../jdkw ./
for p_file in $(find "../samples.properties" -mindepth 1 -maxdepth 1 -type f | sort -r); do
	for test_suffix in ${test_names}; do
		cp -f "${p_file}" jvmw.properties

		test_name="test_execute_${test_suffix}"
		printf ":: execute '%s' from '%s'..." "${test_name}" "${p_file}"

		before_test

		${test_name} && {
		echo " OK";
		after_test;
	} || {
		echo " FAIL($?)";
		echo '----- TEST ENVIRONMENTS :: begin -----'
		env | grep TEST_
		echo '----- TEST ENVIRONMENTS :: end -----'
		echo '----- OUTPUT :: begin -----'
		echo "${TEST_OUTPUT}"
		echo '----- OUTPUT :: end -----'
		after_test;
		exit 1;
	}
	done
done
rm -Rf ./build/