#!/usr/bin/env bash

# Hack for code verification
REQUIRED_UPDATE=${REQUIRED_UPDATE}
JVM_HOME_DIR=${JVM_HOME_DIR}
JVMW_DEBUG=${JVMW_DEBUG}
ARCHIVE_JVM_URL=${ARCHIVE_JVM_URL}
ARCHIVE_EXT=${ARCHIVE_EXT}
ARCHIVE_EXT_TAR_GZ=${ARCHIVE_EXT_TAR_GZ}
ARCHIVE_FILE=${ARCHIVE_FILE}
ARCH=${ARCH}
OS=${OS}
JDK_ROOT_DIR=${JDK_ROOT_DIR}
OTN_USER_AGENT=${OTN_USER_AGENT}
JVM_VERSION=${JVM_VERSION}
JVM_VERSION_MAJOR=${JVM_VERSION_MAJOR}
ARCHIVE_JVM_CHECKSUM=${ARCHIVE_JVM_CHECKSUM}

# BEGIN SCRIPT

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
	JVM_PAGE_URL="https://jdk.java.net/${JVM_VERSION_MAJOR}/"
	openjdk_archive_parser
}

function openjdk_archive_parser() {
	debug "JVM_PAGE_URL='${JVM_PAGE_URL}'"

	local os=${OS}
	if [[ "${os}" == "darwin" ]]; then
		os=osx
	fi

	local -r content=$(curl -s "${JVM_PAGE_URL}")

	local awk_mask='https://download.java.net/java/.*?jdk-'${JVM_VERSION_MAJOR}'.*?'${os}'.*?.'${ARCHIVE_EXT}''

	# 12 - https://download.java.net/java/early_access/jdk12/14/GPL/openjdk-12-ea+14_osx-x64_bin.tar.gz
	# 11 - https://download.java.net/java/ga/jdk11/openjdk-11_osx-x64_bin.tar.gz
	# 10 - https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz
	#  8 - https://download.java.net/java/jdk8u192/archive/b04/binaries/jdk-8u192-ea-bin-b04-macosx-x86_64-01_aug_2018.dmg
	debug "awk_mask=${awk_mask}"

	# shellcheck disable=SC2090
	ARCHIVE_JVM_URL=$(echo "${content}" | awk '{ if (match($0, "\"'${awk_mask}'\"")) print substr($0,RSTART+1, RLENGTH-2)}')

	if [[ ${JVM_VERSION_MAJOR} -ge 9 ]]; then
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
