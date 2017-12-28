#!/usr/bin/env bash

# check required program
function program_exists() {
	for cmd in "$@"; do
		command -v "${cmd}" 1> /dev/null 2>&1 || { echo >&2 "command not found: ${cmd}";
		exit 1; }
	done
}

program_exists "head" "curl" "perl" "awk"

#-------
JVMW_HOME=${HOME}/.jvm
mkdir -p "${JVMW_HOME}"

# default values
JDK_VERSION=${JDK_VERSION:-9}

>&2 echo ":JDK_VERSION=${JDK_VERSION}"

# load properties
JVMW_PROPERTY_FILE="${JVMW_PROPERTY_FILE:-jvmw.properties}"
if [ -f "${JVMW_HOME}/${JVMW_PROPERTY_FILE}" ]; then
	# shellcheck source=/dev/null
	source "${JVMW_HOME}/${JVMW_PROPERTY_FILE}";
fi
if [ -f "${JVMW_PROPERTY_FILE}" ]; then
	# shellcheck source=/dev/null
	source "./${JVMW_PROPERTY_FILE}"
fi
# hack IDE validation
OS=${OS}
JDK_VERSION=${JDK_VERSION}
JVM_NAME=${JVM_NAME}
JDK_HOME=${JDK_HOME}
ARCHIVE_EXT=${ARCHIVE_EXT}
# end hack

#
function build_os() {
	if [[ "$(uname)" == 'Darwin' ]]; then
		echo darwin
	fi
}

function build_archive_extension() {
	if [[ "${OS}" == 'darwin' ]]; then
		echo dmg
	fi
}

#
function build_jdk_name() {
	echo "jdk${JDK_VERSION}"
}

#
function update_jvm() {
	local ARCHIVE_URL
	local ARCHIVE_FILE_NAME

	>&2 echo ":JDK_HOME=${JDK_HOME}"

	ARCHIVE_URL="$(get_latest_jdk_url)"
	>&2 echo ":ARCHIVE_URL=${ARCHIVE_URL}"
	if [[ "$(require_download "${ARCHIVE_URL}")" != "equal" ]]; then
		download_archive "${ARCHIVE_URL}"

		ARCHIVE_FILE_NAME="${JVMW_HOME}/${JVM_NAME}.${ARCHIVE_EXT}"
		>&2 echo ":ARCHIVE_FILE_NAME=${ARCHIVE_FILE_NAME}"

		eval "unpack_archive_${OS}" "${ARCHIVE_FILE_NAME}"
	fi

	date +"%F %R" >"${JVMW_HOME}/.${JVM_NAME}"
}

function download_archive() {
	local ARCHIVE_FILE_NAME="${JVMW_HOME}/${JVM_NAME}.${ARCHIVE_EXT}"
	>&2 echo ":ARCHIVE_FILE_NAME=${ARCHIVE_FILE_NAME}"
	curl -o "${ARCHIVE_FILE_NAME}" -L -H "Cookie: oraclelicense=accept-securebackup-cookie" "$1"
}
