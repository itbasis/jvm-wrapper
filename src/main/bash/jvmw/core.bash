#!/usr/bin/env bash

# Hack for code verification
JVM_VERSION_MAJOR=${JVM_VERSION_MAJOR}
ARCHIVE_FILE=${ARCHIVE_FILE}
ARCHIVE_JVM_CHECKSUM=${ARCHIVE_JVM_CHECKSUM}
ARCHIVE_JVM_URL=${ARCHIVE_JVM_URL}
LAST_UPDATE_FILE=${LAST_UPDATE_FILE}
OTN_USER_AGENT=${OTN_USER_AGENT}
ARCH=${ARCH}
ARCHIVE_EXT=${ARCHIVE_EXT}
REQUIRED_COMMANDS_CORE=${REQUIRED_COMMANDS_CORE}
REQUIRED_COMMANDS_DARWIN=${REQUIRED_COMMANDS_DARWIN}
REQUIRED_COMMANDS_LINUX=${REQUIRED_COMMANDS_LINUX}

# BEGIN SCRIPT
# Hack for code verification
JVMW_DEBUG=${JVMW_DEBUG}
JVMW_HOME=${JVMW_HOME}
JVM_VERSION=${JVM_VERSION}
JVM_VENDOR=${JVM_VENDOR}
CLEAR_COOKIE=${CLEAR_COOKIE}
ORACLE_USER=${ORACLE_USER}
ORACLE_PASSWORD=${ORACLE_PASSWORD}
JVMW_ORACLE_KEYCHAIN=${JVMW_ORACLE_KEYCHAIN}
#
export JVMW=true
#JVMW_HOME=${HOME}/.jvm
if [[ -z "${JVMW_HOME}" ]]; then
	JVMW_HOME="${HOME}/.jvm"
fi
mkdir -p "${JVMW_HOME}"
#
OTN_USER_AGENT='Mozilla/5.0 https://github.com/itbasis/jvm-wrapper'
#
ARCHIVE_EXT_TAR_GZ="tar.gz"
ARCHIVE_EXT_DMG="dmg"
#
JVMW_PROPERTY_FILE="${JVMW_PROPERTY_FILE:-./jvmw.properties}"
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$([[ "$(uname -m)" == "x86_64" ]] && echo "x64" || echo "i586")
ARCHIVE_EXT=$([[ "${OS}" == "darwin" ]] && echo ${ARCHIVE_EXT_DMG} || echo ${ARCHIVE_EXT_TAR_GZ})
#
REQUIRED_COMMANDS_CORE='awk tr head rm mv cd curl readlink dirname'
REQUIRED_COMMANDS_DARWIN='hdiutil xar cpio shasum'
REQUIRED_COMMANDS_LINUX='sha256sum tar'

function log_2() {
	if [[ ! -z "$1" ]]; then
		printf "[%s] [%s" "$1" "${BASH_SOURCE[1]}"
		for i in "${!FUNCNAME[@]}"; do
			printf ":%s(%s)" "${FUNCNAME[$i]}" "${BASH_LINENO[$i]}"
		done
		printf "] "
	fi
	printf "%s\\n" "${*:2}"
}

function print_debug_info() {
	if [[ "${JVMW_DEBUG}" == "Y" ]]; then
		printf ''
		for key in OS ARCH JVMW_HOME ARCHIVE_EXT JVM_VERSION JVM_VERSION_MAJOR JVM_VERSION_UPDATE JDK_ROOT_DIR JDK_HOME_DIR JAVA_HOME_DIR JVM_PAGE_URL ARCHIVE_JVM_URL ARCHIVE_JVM_CHECKSUM ARCHIVE_FILE LAST_UPDATE_FILE REQUIRED_UPDATE JVMW_DEBUG USE_SYSTEM_JVM JVM_VENDOR ORACLE_USER; do
			>&2 log_2 '' "${key}=${!key}";
		done
	fi
}

function debug() {
	if [[ "${JVMW_DEBUG}" == "Y" ]]; then
		>&2 log_2 'DEBUG' "$*"
	fi
}

function die() {
	JVMW_DEBUG=Y
	print_debug_info
	>&2 log_2 'ERROR' "$*"
	exit 1
}

function check_checksum() {
	if [[ ${JVM_VERSION_MAJOR} -lt 8 ]]; then
		# checksum was added only from version 8
		return 0
	fi
	local local_jdk_checksum
	if [[ "${OS}" == "darwin" ]]; then
		local_jdk_checksum=$(shasum -a 256 "${ARCHIVE_FILE}" | cut -d' ' -f 1)
	else
		local_jdk_checksum=$(sha256sum "${ARCHIVE_FILE}" | cut -d' ' -f 1)
	fi
	if [[ "${local_jdk_checksum}" != "${ARCHIVE_JVM_CHECKSUM}" ]]; then
		debug "checksum of archive does not match: local_jdk_checksum=${local_jdk_checksum}, ARCHIVE_JVM_CHECKSUM=${ARCHIVE_JVM_CHECKSUM}"
		return 1
	fi
	return 0
}

function write_last_update() {
	local -r now=$(date +"%F %R")

	if [[ -z "${ARCHIVE_JVM_URL}" ]]; then
		printf "%s\\n%s" "${now}" "$(tail -n2 "${LAST_UPDATE_FILE}")" >"${LAST_UPDATE_FILE}"
	else
		printf "%s\\n%s\\n%s" "${now}" "${ARCHIVE_JVM_URL}" "${ARCHIVE_JVM_CHECKSUM}" >"${LAST_UPDATE_FILE}"
	fi
}

function whereis() {
	for path in ${PATH//:/ }; do
		if [[ -f "${path}/${1}" ]]; then
			echo "${path}/${1}"
			return 0
		fi
	done
}

function system_check_program_exists() {
	# shellcheck disable=SC2068
	for cmd in $@; do
		if [[ "$("$cmd" --version 2>&1)" == *"command not found"* ]]; then
			die "command not found: ${cmd}"
		fi
	done
}

# END SCRIPT
