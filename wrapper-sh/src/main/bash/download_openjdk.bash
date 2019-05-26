#!/usr/bin/env bash

# Hack for code verification
REQUIRED_UPDATE=${REQUIRED_UPDATE}
JVM_HOME_DIR=${JVM_HOME_DIR}
JVMW_DEBUG=${JVMW_DEBUG}
ARCHIVE_JVM_URL=${ARCHIVE_JVM_URL}
ARCHIVE_EXT=${ARCHIVE_EXT}
ARCHIVE_EXT_TAR_GZ=${ARCHIVE_EXT_TAR_GZ}
ARCHIVE_EXT_ZIP=${ARCHIVE_EXT_ZIP}
ARCHIVE_FILE=${ARCHIVE_FILE}
ARCH=${ARCH}
OS=${OS}
JDK_ROOT_DIR=${JDK_ROOT_DIR}
OTN_USER_AGENT=${OTN_USER_AGENT}
JVM_VERSION=${JVM_VERSION}
JVM_VERSION_MAJOR=${JVM_VERSION_MAJOR}
ARCHIVE_JVM_CHECKSUM=${ARCHIVE_JVM_CHECKSUM}
IS_MAC_OS=${IS_MAC_OS}

# BEGIN SCRIPT

# Reference Implementations
RI_VERSION_MAX=11

function openjdk_check_the_need_for_downloading() {
	if [[ "${REQUIRED_UPDATE}" != "Y" ]]; then
		return 0
	fi
	if [[ ! -f "${JVM_HOME_DIR}/bin/java" ]]; then
		REQUIRED_UPDATE=Y
	else
		check_is_out_of_date
	fi

	if [[ "${REQUIRED_UPDATE}" != "Y" ]]; then
		debug "not required update"
		return 0
	fi

	openjdk_latest_version_page_parser

	if [[ ${ARCHIVE_JVM_URL} == *"${JVM_VERSION}"* ]] && [[ "${REQUIRED_UPDATE}" != "Y" ]]; then
		write_last_update
		return 0
	fi
}

function openjdk_latest_version_page_parser() {
	if [[ ${JVM_VERSION_MAJOR} -gt ${RI_VERSION_MAX} ]]; then
		JVM_PAGE_URL="https://jdk.java.net/${JVM_VERSION_MAJOR}/"
	else
		if [[ ${IS_MAC_OS} ]]; then
			die "MacOS does not support OpenJDK ${RI_VERSION_MAX} or below."
		fi
		JVM_PAGE_URL="https://jdk.java.net/java-se-ri/${JVM_VERSION_MAJOR}"
	fi
	openjdk_archive_parser
}

function openjdk_archive_parser() {
	debug "JVM_PAGE_URL='${JVM_PAGE_URL}'"

	local os=${OS}
	if [[ ${IS_MAC_OS} ]]; then
		os=osx
	fi
	local arch=${ARCH}
	if [[ ${IS_MAC_OS} ]] && [[ ${JVM_VERSION_MAJOR} -le 8 ]]; then
		arch="x86_64"
	fi

	local -r content=$(curl -s "${JVM_PAGE_URL}")

	local awk_mask
	if [[ ${JVM_VERSION_MAJOR} -gt ${RI_VERSION_MAX} ]]; then
		awk_mask='https://download.java.net/java/.*?jdk-'${JVM_VERSION_MAJOR}'.*?'${os}'.*?-'${arch}'.*?.'${ARCHIVE_EXT}''
	else
		if [[ ${JVM_VERSION_MAJOR} -eq '9' ]]; then
			ARCHIVE_EXT=${ARCHIVE_EXT_ZIP}
		fi
		awk_mask='https://download.java.net/openjdk/jdk'${JVM_VERSION_MAJOR}'.*?/ri/.*?'${os}'.*?.'${ARCHIVE_EXT}''
	fi
	debug "awk_mask=${awk_mask}"

	# shellcheck disable=SC2090,SC2086
	ARCHIVE_JVM_URL=$(echo "${content}" | awk '{ if (match($0, "\"'${awk_mask}'\"")) print substr($0,RSTART+1, RLENGTH-2)}' | head -n 1)
	debug "ARCHIVE_JVM_URL.. = ${ARCHIVE_JVM_URL}"

	if [[ ${JVM_VERSION_MAJOR} -ge 9 ]]; then
		# shellcheck disable=SC2086
		local -r content_url=$(echo "${content}" | awk '{ if (match($0, "\"'${awk_mask}'.sha256\"")) print substr($0,RSTART+1, RLENGTH-2)}')
		ARCHIVE_JVM_CHECKSUM=$(curl -s "${content_url}")
	fi
}

function openjdk_download_jdk() {
	debug "download ${ARCHIVE_JVM_URL}..."

	curl -kL -A "${OTN_USER_AGENT}" -o "${ARCHIVE_FILE}" "${ARCHIVE_JVM_URL}"

	if [[ "${JVMW_DEBUG}" == "Y" ]]; then
		ls -laFh "${ARCHIVE_FILE}"
	fi

	#	if [[ ! `check_checksum` ]]; then
	#		die
	#	fi
}

# END SCRIPT
