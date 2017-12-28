#!/usr/bin/env bash

program_exists "head" "curl" "perl"

# hack IDE validation
JDK_VERSION=${JDK_VERSION}
ARCHIVE_EXT=${ARCHIVE_EXT}
ARCHIVE_URL=${ARCHIVE_URL}
JDK_HOME=${JDK_HOME}
# end hack

function get_latest_jdk_url() {
	>&2 echo "::get_latest_jdk_url"
	>&2 echo ":ARCHIVE_EXT=${ARCHIVE_EXT}"

	# shellcheck disable=SC2026
	JDK_DOWNLOAD_PAGE=http://www.oracle.com$(curl -s http://www.oracle.com/technetwork/java/javase/downloads/index.html | JDK=${JDK_VERSION} perl -nle '/name="JDK$ENV{'JDK'}".*?"(\/technetwork\/.*?\/jdk$ENV{'JDK'}-downloads-\d+.html)"/ && print $1')
	>&2 echo ":JDK_DOWNLOAD_PAGE=${JDK_DOWNLOAD_PAGE}"

	# shellcheck disable=SC2026
	JDK_ARCHIVE_URL=$(curl -s "${JDK_DOWNLOAD_PAGE}" | ARCHIVE_EXT="${ARCHIVE_EXT}" perl -nle '/(http.*?\.$ENV{'ARCHIVE_EXT'})/ && print $1' | head -1)
	>&2 echo ":JDK_ARCHIVE_URL=${JDK_ARCHIVE_URL}"

	echo "${JDK_ARCHIVE_URL}"
}

function require_download() {
	>&2 echo "::require_download"
	>&2 echo ":ARCHIVE_URL=${ARCHIVE_URL}"

	# shellcheck disable=SC1117
	current_version=$(eval "${JDK_HOME}/bin/java -version 2>&1" | sed -nE "s/.*\(build (.*[0-9])\).*/\1/p" | head -1)

	if [[ "${JDK_VERSION}" -ge 9 ]]; then
		# shellcheck disable=SC1117
		latest_version=$(echo "${ARCHIVE_URL}" | sed -nE "s/.*\/jdk\/(.*[0-9])\/jdk.*/\1/p" | head -1)
	else
		# shellcheck disable=SC1117
		latest_version=$(echo "${ARCHIVE_URL}" | sed -nE "s/.*\/jdk\/([0-9])u([0-9]*)-(b[0-9]*).*/1.\1.0_\2-\3/p" | head -1)
	fi

	>&2 echo ":current_version=${current_version}"
	>&2 echo ":latest_version=${latest_version}"

	if [[ "${latest_version}" == "${current_version}" ]]; then
		echo "equal"
	fi
}