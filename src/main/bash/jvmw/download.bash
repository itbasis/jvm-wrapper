#!/usr/bin/env bash

# Hack for code verification
OS=${OS}
REQUIRED_UPDATE=${REQUIRED_UPDATE}
JVM_VENDOR=${JVM_VENDOR}
ARCHIVE_JVM_URL=${ARCHIVE_JVM_URL}
JVM_PAGE_URL=${JVM_PAGE_URL}
LAST_UPDATE_FILE=${LAST_UPDATE_FILE}
ARCHIVE_FILE=${ARCHIVE_FILE}
JVM_VERSION=${JVM_VERSION}
JVM_VERSION_MAJOR=${JVM_VERSION_MAJOR}
JDK_HOME_DIR=${JDK_HOME_DIR}
JVM_HOME_DIR=${JVM_HOME_DIR}

# BEGIN SCRIPT
function download_jdk() {
	eval "${JVM_VENDOR}_check_the_need_for_downloading"

	debug "REQUIRED_UPDATE=${REQUIRED_UPDATE}"
	if [[ "${REQUIRED_UPDATE}" != "Y" ]]; then
		return 0
	fi

	if [[ -z "${ARCHIVE_JVM_URL}" ]]; then
		die "empty ARCHIVE_JVM_URL. Use page '${JVM_PAGE_URL}'"
	fi
	#
	if [[ -f "${LAST_UPDATE_FILE}" ]] && [[ "${ARCHIVE_JVM_URL}" == "$(head -2 <"${LAST_UPDATE_FILE}" | tail -1)" ]]; then
		return 0
	fi
	#
	if [[ -f "${ARCHIVE_FILE}" ]]; then
		if [[ ${JVM_VERSION_MAJOR} -lt 8 ]]; then
			# TODO
			rm -f "${ARCHIVE_FILE}"
		elif check_checksum; then
			unpack
			return 0
		fi
	fi
	#
	if [[ -d "${JDK_HOME_DIR}" ]]; then
		if [[ "$("${JVM_HOME_DIR}/bin/java" -fullversion 2>&1)" == *"${JVM_VERSION}"* ]]; then
			write_last_update
			return 0
		fi
	fi
	#
	eval "${JVM_VENDOR}_download_jdk"

	unpack

	write_last_update
}

# END SCRIPT
