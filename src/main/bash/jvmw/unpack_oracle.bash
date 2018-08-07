#!/usr/bin/env bash

# Hack for code verification
JVM_FULL_NAME=${JVM_FULL_NAME}
ARCHIVE_FILE=${ARCHIVE_FILE}
JDK_ROOT_DIR=${JDK_ROOT_DIR}

# BEGIN SCRIPT
function oracle_unpack_darwin() {
	hdiutil detach "/Volumes/${JVM_FULL_NAME}" -quiet -force 2> /dev/null
	hdiutil attach "${ARCHIVE_FILE}" -mountpoint "/Volumes/${JVM_FULL_NAME}" 2>&1 || die
	local -r PKG_FILE_NAME=$(find "/Volumes/${JVM_FULL_NAME}" -mindepth 1 -maxdepth 1 -name '*.pkg')
	local -r tmp_dir=$(mktemp -d -t "${JVM_FULL_NAME}.XXXXXX")/
	cd "${tmp_dir}/" || { rm -Rf "${tmp_dir}";
		die "can't change directory: ${tmp_dir}/"; }
	xar -xf "${PKG_FILE_NAME}" . &> /dev/null || die
	for dir in ./*jdk*; do
		cpio -i <"${dir}/Payload" || exit 1
	done
	mv Contents "${JDK_ROOT_DIR}" 1> /dev/null 2>&1 || die
	cd - || die
	rm -Rf "${tmp_dir}" "${ARCHIVE_FILE}"
	#
	hdiutil detach "/Volumes/${JVM_FULL_NAME}" -force || die
}

function oracle_unpack_linux() {
	local -r tmp_dir=$(mktemp -d -t "${JVM_FULL_NAME}.XXXXXX")/
	debug "tmp_dir=${tmp_dir}"
	tar xf "${ARCHIVE_FILE}" -C "${tmp_dir}" || { rm -Rf "${tmp_dir}";
		die 'error unpack archive...'; }
	mv "$(find "${tmp_dir}" -mindepth 1 -maxdepth 1 -type d)" "${JDK_ROOT_DIR}" || { rm -Rf "${tmp_dir}";
		die 'error move unpacked jdk...'; }
	rm -Rf "${tmp_dir}" "${ARCHIVE_FILE}"
}

# END SCRIPT
