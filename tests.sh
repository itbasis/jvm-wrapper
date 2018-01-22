#!/usr/bin/env bash

JVMW=${1:-./jdkw}
JVMW_FILE=${JVMW_FILE}
JDK_VERSION_MAJOR=${JDK_VERSION_MAJOR}
CHECK_JDK_VERSION=${CHECK_JDK_VERSION}
CHECK_JDK_ROOT_DIR=${CHECK_JDK_ROOT_DIR}
LAST_UPDATE_FILE=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}.last_update
OS=$(uname | tr '[:upper:]' '[:lower:]')
#

function clean(){
	rm -Rf ./build/ ./jvmw.properties ./jvmw.properties.bak "${LAST_UPDATE_FILE}"
}
#
function log_cmd() {
	>&2 echo --- cmd: "'$@'" --- ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[0]}
}

function log_test() {
	>&2 echo --- test: "$@" --- ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[1]}:${BASH_LINENO[0]}
}

function error() {
	>&2 echo --- capture output :: begin ---
	>&2 echo "${output}"
	>&2 echo --- capture output :: end ---
	>&2 echo --- error :: ${BASH_SOURCE[0]}:${FUNCNAME[1]}:${BASH_LINENO[1]}:${BASH_LINENO[0]} ---
	clean
	exit 1
}

#
function check_output() {
	# shellcheck disable=SC2086
	log_test "check '$1' contains '$2'"
	local -r cmd="${JVMW} $1 2>&1"
	log_cmd "${cmd}"
	output=$(eval "${cmd}" 2>&1)
	if [[ ${output} != *"$2"* ]]; then
		error
	fi
}

function prepare_test(){
	clean
	if [ -f "samples/${JVMW_FILE}" ]; then
		cp "samples/${JVMW_FILE}" jvmw.properties
	fi
}

#
prepare_test
echo -e "\nREQUIRED_UPDATE=N" >> jvmw.properties
rm -Rf "${LAST_UPDATE_FILE}" ${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/
check_output 'java -version' "java: No such file"
log_test "check not call function 'otn_page_archive_jdk_parser'"
if [[ ${output} == *"otn_page_archive_jdk_parser"* ]]; then
	error
fi

#
prepare_test
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
if [[ ${output} == *"[DEBUG]"* ]]; then
	error
fi

prepare_test
echo -e "\nJVMW_DEBUG=Y" >> jvmw.properties

#
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
log_test "check call function 'otn_page_archive_jdk_parser'"
if [[ ${output} != *"otn_page_archive_jdk_parser"* ]]; then
	error
fi

#
log_test "check not call function 'otn_page_archive_jdk_parser'"
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
if [[ ${output} == *"otn_page_archive_jdk_parser"* ]]; then
	error
fi
log_test "check contains 'prev_date'"
if [[ ${output} != *"prev_date="* ]]; then
	error
fi

#
log_test "check call function 'otn_page_archive_jdk_parser'"
fake_date=$([[ "${OS}" == "darwin" ]] && echo "$(date -v -2d +"%F %R"))" || echo "$(date --date="-2 days" '+%F %R')")
printf "%s" "${fake_date}" >"${LAST_UPDATE_FILE}"
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
if [[ ${output} != *"otn_page_archive_jdk_parser"* ]]; then
	error
fi
printf "%s\nfake" "${fake_date}" >"${LAST_UPDATE_FILE}"
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
if [[ ${output} != *"otn_page_archive_jdk_parser"* ]]; then
	error
fi
printf "%s\nfake\nfake" "${fake_date}" >"${LAST_UPDATE_FILE}"
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
if [[ ${output} != *"otn_page_archive_jdk_parser"* ]]; then
	error
fi

#
cp jvmw.properties jvmw.properties.bak
echo 'REQUIRED_UPDATE=N' >> jvmw.properties
printf "%s\nfake\nfake" "${fake_date}" >"${LAST_UPDATE_FILE}"
check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
log_test "check not call function 'otn_page_archive_jdk_parser'"
if [[ ${output} == *"otn_page_archive_jdk_parser"* ]]; then
	error
fi
log_test "check not contains 'prev_date'"
if [[ ${output} == *"prev_date="* ]]; then
	error
fi
cp jvmw.properties.bak jvmw.properties

#

check_output 'info' "JDK_HOME=${HOME}/.jvm/${CHECK_JDK_ROOT_DIR}/"
check_output 'javac -version' "${CHECK_JDK_VERSION}"
check_output 'java -version' "${CHECK_JDK_VERSION}"

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
check_output 'java -cp ./build/test/ Test' "${CHECK_JDK_VERSION}"
#
clean