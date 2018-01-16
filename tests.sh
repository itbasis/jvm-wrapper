#!/usr/bin/env bash

JVMW=${1:-./jdkw}
JVMW_FILE=${JVMW_FILE}
JDK_VERSION_MAJOR=${JDK_VERSION_MAJOR}
CHECK_JDK_VERSION=${CHECK_JDK_VERSION}
CHECK_JDK_ROOT_DIR=${CHECK_JDK_ROOT_DIR}
LAST_UPDATE_FILE=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}.last_update
#
rm -Rf ./build/ ./jvmw.properties "${LAST_UPDATE_FILE}"
#

function log_cmd() {
	>&2 echo --- cmd: "'$@'" --- ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[0]}
}

function log_test() {
	>&2 echo --- test: "'$@'" --- ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[0]}
}

function error() {
	>&2 echo --- capture output :: begin ---
	>&2 echo "$1"
	>&2 echo --- capture output :: end ---
	>&2 echo --- error :: ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[0]} ---
	rm -Rf ./build/test/ > /dev/null 2>&1
	exit 1
}

#
function check_output() {
	# shellcheck disable=SC2086
	log_test "check '$1' contains '$2'"
	local -r cmd="${JVMW} $1 2>&1"
	log_cmd "${cmd}"
	local -r output=$(eval "${cmd}" 2>&1)
	if [[ ${output} != *"$2"* ]]; then
		error "${output}"
	fi
	echo "${output}"
}

#
if [ -f "samples/${JVMW_FILE}" ]; then
	cp "samples/${JVMW_FILE}" jvmw.properties
fi
#
output=$(check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/")

log_test "check call function 'otn_page_archive_jdk_parser'"
if [[ ${output} != *"otn_page_archive_jdk_parser"* ]]; then
	error "${output}"
fi

log_test "check not call function 'otn_page_archive_jdk_parser'"
output=$(check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/" 2>&1)
if [[ ${output} == *"otn_page_archive_jdk_parser"* ]]; then
	error "${output}"
fi
log_test "check contains 'prev_date'"
if [[ ${output} != *"prev_date="* ]]; then
	error "${output}"
fi

log_test "check not call function 'otn_page_archive_jdk_parser'"
sed -i "" "1s/.*/$(date -v -2d +"%F %R")/" "${LAST_UPDATE_FILE}"
if [[ ${output} == *"otn_page_archive_jdk_parser"* ]]; then
	error "${output}"
fi

log_test "check call function 'otn_page_archive_jdk_parser'"
sed -i "" "1s/.*/$(date -v -2d +"%F %R")/" "${LAST_UPDATE_FILE}"
sed -i "" "2s/.*/fake/" "${LAST_UPDATE_FILE}"
sed -i "" "3s/.*/fake/" "${LAST_UPDATE_FILE}"
output=$(check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/" 2>&1)
if [[ ${output} != *"otn_page_archive_jdk_parser"* ]]; then
	error "${output}"
fi

check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/" > /dev/null
check_output 'javac -version' "${CHECK_JDK_VERSION}" > /dev/null
check_output 'java -version' "${CHECK_JDK_VERSION}" > /dev/null

#
mkdir -p ./build/test
cmd='javac -d ./build/test test/Test.java'
# shellcheck disable=SC2086
output=$("${JVMW}" ${cmd} 2>&1)
log_test "check '${cmd}'"
if [[ ! -f "./build/test/Test.class" ]]; then
	error "${output}"
fi
#
check_output 'java -cp ./build/test/ Test' "${CHECK_JDK_VERSION}" > /dev/null
rm -Rf ./build/test/