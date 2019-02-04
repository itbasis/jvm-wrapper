#!/usr/bin/env bash

# Hack for code verification
JVM_FULL_NAME=${JVM_FULL_NAME}
ARCHIVE_FILE=${ARCHIVE_FILE}
JDK_ROOT_DIR=${JDK_ROOT_DIR}
ARCHIVE_EXT=${ARCHIVE_EXT}
ARCHIVE_EXT_ZIP=${ARCHIVE_EXT_ZIP}
ARCHIVE_EXT_DMG=${ARCHIVE_EXT_DMG}
ARCHIVE_EXT_TAR_GZ=${ARCHIVE_EXT_TAR_GZ}
JVM_VENDOR=${JVM_VENDOR}
OS=${OS}

# BEGIN SCRIPT
function unpack() {
	if [[ "${ARCHIVE_EXT}" == "${ARCHIVE_EXT_TAR_GZ}" ]]; then
		unpack_tar_gz
	elif [[ "${ARCHIVE_EXT}" == "${ARCHIVE_EXT_DMG}" ]]; then
		unpack_dmg
	elif [[ "${ARCHIVE_EXT}" == "${ARCHIVE_EXT_ZIP}" ]]; then
		unpack_zip
	else
		eval "${JVM_VENDOR}_unpack_${OS}"
	fi
	rm -f "${ARCHIVE_FILE}"
}

function unpack_tar_gz() {
	local sub_dir
	local -r tmp_dir=$(mktemp -d -t "${JVM_FULL_NAME}.XXXXXX")/
	debug "tmp_dir=${tmp_dir}"
	tar xf "${ARCHIVE_FILE}" -C "${tmp_dir}" || { rm -Rf "${tmp_dir}";
		die 'error unpack archive...'; }
	sub_dir=$(find "${tmp_dir}" -mindepth 1 -maxdepth 1 -type d)
	mv "${sub_dir}" "${JDK_ROOT_DIR}" || { rm -Rf "${tmp_dir}";
		die 'error move unpacked jdk...'; }
	rm -Rf "${tmp_dir}"

	if [[ -d "${JDK_ROOT_DIR}/Contents" ]]; then
		mv "${JDK_ROOT_DIR}"/Contents/* "${JDK_ROOT_DIR}/"
		rm -Rf "${JDK_ROOT_DIR}"/Contents/
	fi
}

function unpack_dmg() {
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
	rm -Rf "${JDK_ROOT_DIR}"
	mv Contents "${JDK_ROOT_DIR}" 1> /dev/null 2>&1 || die
	cd - || die
	rm -Rf "${tmp_dir}"
	#
	hdiutil detach "/Volumes/${JVM_FULL_NAME}" -force || die
}

function unpack_zip() {
	local sub_dir
	local -r tmp_dir=$(mktemp -d -t "${JVM_FULL_NAME}.XXXXXX")
	debug "tmp_dir=${tmp_dir}"
	unzip "${ARCHIVE_FILE}" -d "${tmp_dir}" > /dev/null || { rm -Rf "${tmp_dir}";
		die 'error unpack archive...'; }
	sub_dir=$(find "${tmp_dir}" -mindepth 1 -maxdepth 1 -type d)
	sub_dir=$(find "${sub_dir}" -mindepth 1 -maxdepth 1 -type d)
	debug "sub_dir=${sub_dir}"
	mv "${sub_dir}" "${JDK_ROOT_DIR}" || { rm -Rf "${tmp_dir}";
		die 'error move unpacked jdk...'; }
	rm -Rf "${tmp_dir}"
}

# END SCRIPT
