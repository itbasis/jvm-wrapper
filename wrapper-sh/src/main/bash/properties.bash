#!/usr/bin/env bash

# Hack for code verification
OS=${OS}
JVMW_HOME=${JVMW_HOME}
JVM_VERSION=${JVM_VERSION}
JVM_VENDOR=${JVM_VENDOR}
ARCHIVE_FILE=${ARCHIVE_FILE}
ARCHIVE_EXT=${ARCHIVE_EXT}
LAST_UPDATE_FILE=${LAST_UPDATE_FILE}

# BEGIN SCRIPT
function properties_parser() {
	while IFS='=' read -r key value || [[ -n "$key" ]]; do
		[[ -n "${key}" ]] && [[ -z "${!key}" ]] && { debug "${key}='${value}'"; eval "${key}='${value}'"; }
	done <<<"$1"
}

function properties_default() {
	cat << EOF
JVM_VERSION=11
REQUIRED_UPDATE=Y
CLEAR_COOKIE=Y
JVMW_DEBUG=N
USE_SYSTEM_JVM=N
JVM_VENDOR=openjdk
JVMW_ORACLE_KEYCHAIN=JVM_WRAPPER_ORACLE
EOF
}

function properties_build() {
	JVM_VERSION_MAJOR="${JVM_VERSION%_*}"
	JVM_VERSION_MAJOR="${JVM_VERSION_MAJOR#1.*}"
	JVM_VERSION_MAJOR="${JVM_VERSION_MAJOR%%.*}"
	JVM_VERSION_MAJOR="${JVM_VERSION_MAJOR%%u*}"
	if [[ "${JVM_VERSION}" != "${JVM_VERSION_MAJOR}" ]]; then
		JVM_VERSION_UPDATE="${JVM_VERSION##*.}"
		JVM_VERSION_UPDATE="${JVM_VERSION_UPDATE##*_}"
		JVM_VERSION_UPDATE="${JVM_VERSION_UPDATE##*u}"
		JVM_VERSION_UPDATE="${JVM_VERSION_UPDATE%%-b*}"
	else
		unset JVM_VERSION_UPDATE
	fi

	JVM_FULL_NAME="${JVM_VENDOR}-jdk-"
	if [[ ${JVM_VERSION_MAJOR} -lt 9 ]]; then
		JVM_FULL_NAME="${JVM_FULL_NAME}${JVM_VERSION_MAJOR}"
		if [[ -n "${JVM_VERSION_UPDATE}" ]]; then
			JVM_FULL_NAME="${JVM_FULL_NAME}u${JVM_VERSION_UPDATE}"
		fi
	else
		JVM_FULL_NAME="${JVM_FULL_NAME}${JVM_VERSION}"
	fi

	JDK_ROOT_DIR=${JVMW_HOME}/${JVM_FULL_NAME}

	ARCHIVE_FILE=${JDK_ROOT_DIR}.${ARCHIVE_EXT}
	LAST_UPDATE_FILE=${JDK_ROOT_DIR}.last_update

	JDK_HOME_DIR=${JDK_ROOT_DIR}/$([[ "${OS}" == 'darwin' ]] && echo 'Home/')
}

# END SCRIPT

# Hack for code verification
export ARCHIVE_FILE LAST_UPDATE_FILE JDK_HOME_DIR
