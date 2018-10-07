#!/usr/bin/env bash

# Hack for code verification
OS=${OS}
JVM_VERSION_MAJOR=${JVM_VERSION_MAJOR}
ARCHIVE_EXT=${ARCHIVE_EXT}
ARCHIVE_EXT_TAR_GZ=${ARCHIVE_EXT_TAR_GZ}
ARCHIVE_FILE=${ARCHIVE_FILE}
JDK_ROOT_DIR=${JDK_ROOT_DIR}

# BEGIN SCRIPT
function openjdk_prepare_actions() {
	if [[ "${OS}" == "darwin" ]] && [[ ${JVM_VERSION_MAJOR} -ge 9 ]]; then
		ARCHIVE_EXT=${ARCHIVE_EXT_TAR_GZ}
		ARCHIVE_FILE=${JDK_ROOT_DIR}.${ARCHIVE_EXT}
	fi
}

# END SCRIPT
