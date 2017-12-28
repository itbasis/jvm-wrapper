#!/usr/bin/env bash

program_exists "curl" "hdiutil" "xar" "cpio"

# hack IDE validation
JVMW_HOME=${JVMW_HOME}
JVM_NAME=${JVM_NAME}
ARCHIVE_EXT=${ARCHIVE_EXT}
# end hack

function unpack_archive_darwin() {
	ARCHIVE_FILE_NAME=$1
	>&2 echo ":ARCHIVE_FILE_NAME=${ARCHIVE_FILE_NAME}"
	>&2 ls "${ARCHIVE_FILE_NAME}"

	hdiutil detach "/Volumes/${JVM_NAME}" -quiet -force 2>/dev/null
	hdiutil attach "${ARCHIVE_FILE_NAME}" -quiet -mountpoint "/Volumes/${JVM_NAME}"
	PKG_FILE_NAME=$(find "/Volumes/${JVM_NAME}" -maxdepth 1 -name '*.pkg')
	>&2 echo ":PKG_FILE_NAME=${PKG_FILE_NAME}"
	>&2 ls "${PKG_FILE_NAME}"

	mkdir -p "${JVMW_HOME}/${JVM_NAME}.tmp"
	cd "${JVMW_HOME}/${JVM_NAME}.tmp/" || { echo "can't change directory: ${JVMW_HOME}/${JVM_NAME}.tmp/"; exit 1; }
	xar -xf "${PKG_FILE_NAME}" . &> /dev/null
	>&2 ls .
	for dir in ./*jdk*; do
		cpio -i <"${dir}/Payload"
	done
	rm -Rf "${JVMW_HOME:?}/${JVM_NAME}/"
	mv Contents "../${JVM_NAME}" 1>/dev/null 2>&1
	cd - || exit 1
	rm -Rf "${JVMW_HOME:?}/${JVM_NAME}.tmp/" "${ARCHIVE_FILE_NAME}"
	#
	hdiutil detach "/Volumes/${JVM_NAME}" -quiet -force
}

function calculate_jdk_home_darwin() {
	>&2 echo ":calculate_jdk_home_darwin"
	>&2 echo ":JVMW_HOME=${JVMW_HOME}"
	>&2 echo ":JVM_NAME=${JVM_NAME}"
	echo "${JVMW_HOME}/${JVM_NAME}/Home"
}
