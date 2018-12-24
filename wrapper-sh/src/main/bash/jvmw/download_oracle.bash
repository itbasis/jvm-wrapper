#!/usr/bin/env bash

# Hack for code verification
OTN_USER_AGENT=${OTN_USER_AGENT}
ORACLE_USER=${ORACLE_USER}
ORACLE_PASSWORD=${ORACLE_PASSWORD}
OS=${OS}
JVMW_ORACLE_KEYCHAIN=${JVMW_ORACLE_KEYCHAIN}
JVMW_DEBUG=${JVMW_DEBUG}
ARCHIVE_FILE=${ARCHIVE_FILE}
ARCHIVE_JVM_CHECKSUM=${ARCHIVE_JVM_CHECKSUM}
REQUIRED_UPDATE=${REQUIRED_UPDATE}
JVM_HOME_DIR=${JVM_HOME_DIR}
JVM_VERSION=${JVM_VERSION}
JVM_VERSION_MAJOR=${JVM_VERSION_MAJOR}
JVM_VERSION_UPDATE=${JVM_VERSION_UPDATE}
ARCH=${ARCH}
ARCHIVE_EXT=${ARCHIVE_EXT}
CLEAR_COOKIE=${CLEAR_COOKIE}


# BEGIN SCRIPT
function oracle_otn_curl_send_request() {
	local -r url="$1"
	debug "url='${url}'"
	local -r CURL_OPTIONS="${*:2}"
	# shellcheck disable=SC2086
	curl -kLs -A "${OTN_USER_AGENT}" -D "${OTN_HEADERS_FILE}" -b "${OTN_COOKIE_FILE}" -c "${OTN_COOKIE_FILE}" ${CURL_OPTIONS} "${url}" >"${OTN_CONTENT_FILE}"
}

function oracle_otn_curl_post() {
	oracle_otn_form_parser
	oracle_otn_curl_send_request "${OTN_FORM_ACTION}" -X POST -d "${OTN_FORM_DATA}"
}

function ont_form_data_build() {
	IFS='>'
	local form_data=
	for fld in $(echo "$1" | awk '{ if (match($0, "<input")) print }'); do
		fld_name=$(echo "${fld}" | awk 'match($0, /name="([^"]+)/) { print substr($0, RSTART+6, RLENGTH-6) }')
		fld_value=$(echo "${fld}" | awk 'match($0, /value="([^"]+)/) { print substr($0, RSTART+7, RLENGTH-7) }')

		if [[ ! -z "${fld_name}" ]]; then
			if [[ "${fld_name}" == "userid" ]]; then
				fld_value=${ORACLE_USER}
			elif [[ "${fld_name}" == "pass" ]]; then
				fld_value=${ORACLE_PASSWORD}
			fi
			form_data="${form_data}&${fld_name}=${fld_value}"
		fi
	done
	echo "${form_data}"
}

function oracle_otn_form_clean_env() {
	unset oracle_otn_FORM_DATA oracle_otn_FORM_ACTION
}

function oracle_otn_form_parser() {
	oracle_otn_form_clean_env

	OTN_FORM_DATA=$(ont_form_data_build "$(cat "${OTN_CONTENT_FILE}")")
	OTN_FORM_ACTION=$(awk 'match($0, /action="([^"]+)/) { print substr($0, RSTART+8, RLENGTH-8) }' <"${OTN_CONTENT_FILE}")
	if [[ "${OTN_FORM_ACTION:0:1}" == "/" ]]; then
		OTN_FORM_ACTION="${OTN_HOST_LOGIN}${OTN_FORM_ACTION}"
	fi
}

function oracle_otn_curl_redirect() {
	# shellcheck disable=SC2155
	local host=$(awk '{ if (match($0, "http-equiv=\"refresh\".*")) print substr($0, RSTART, RLENGTH) }' <"${OTN_CONTENT_FILE}" | awk -F';' '{ if (match($0, "URL=[^\"]+")) print substr($0, RSTART+4, RLENGTH-4)}')
	if [[ "${host:0:1}" == "/" ]]; then
		host="${OTN_HOST_LOGIN}${host}"
	fi
	oracle_otn_curl_send_request "${host}"
}

function oracle_otn_login() {
	OTN_COOKIE_FILE="${TMPDIR}/jvmwrapper.oracle_otn.cookie"

	if [[ "${CLEAR_COOKIE}" == "Y" ]]; then
		rm -f "${OTN_COOKIE_FILE}";
	fi
	if [[ -f "${OTN_COOKIE_FILE}" ]]; then
		return 0
	fi

	if [[ -z "${ORACLE_USER}" ]] || [[ -z "${ORACLE_PASSWORD}" ]]; then
		case "${OS}" in
			darwin)
				if [[ ! -z "${JVMW_ORACLE_KEYCHAIN}" ]]; then
					ORACLE_USER="$(security 2>&1 find-generic-password -l "${JVMW_ORACLE_KEYCHAIN}" | awk 'match($0, /\"acct\"<blob>=\"([^\"]+)/) { print substr($0, RSTART+14, RLENGTH-14) }')"
				fi
				if [[ ! -z "${ORACLE_USER}" ]]; then
					ORACLE_PASSWORD="$(security 2>&1 find-generic-password -g -a "${ORACLE_USER}" | awk 'match($0, /password: \"([^\"]+)/) { print substr($0, RSTART+11, RLENGTH-11) }')"
				fi
			;;
		esac
	fi
	if [[ -z "${ORACLE_USER}" ]] || [[ -z "${ORACLE_PASSWORD}" ]]; then
		die 'no values were found in ORACLE_USER and ORACLE_PASSWORD'
	fi

	debug "login OTN as '${ORACLE_USER}'"

	OTN_HEADERS_FILE=$(mktemp -t oracle_otn_HEADERS_XXXXX.tmp)
	OTN_CONTENT_FILE=$(mktemp -t oracle_otn_CONTENT_XXXXX.tmp)
	OTN_URL_INDEX=https://www.oracle.com/index.html
	OTN_HOST_LOGIN=https://login.oracle.com
	OTN_URL_SIGNON="https://www.oracle.com/webapps/redirect/signon?nexturl=${OTN_URL_INDEX}"

	oracle_otn_curl_send_request "${OTN_URL_SIGNON}"
	oracle_otn_curl_post
	oracle_otn_curl_post
	oracle_otn_curl_redirect
	oracle_otn_curl_post
	oracle_otn_curl_send_request "${OTN_URL_SIGNON}"
	rm -f "${OTN_HEADERS_FILE}" "${OTN_CONTENT_FILE}"
}

function oracle_download_jdk() {
	if [[ "${ARCHIVE_JVM_URL}" != *'/otn-pub/'* ]]; then
		oracle_otn_login
	fi

	debug "download ${ARCHIVE_JVM_URL}..."
	curl -kL -A "${OTN_USER_AGENT}" -b "${OTN_COOKIE_FILE}" -o "${ARCHIVE_FILE}" --cookie "oraclelicense=accept-securebackup-cookie" "${ARCHIVE_JVM_URL}"

	rm -f "${OTN_HEADERS_FILE}" "${OTN_CONTENT_FILE}"
	if [[ "${CLEAR_COOKIE}" == "Y" ]]; then
		rm -f "${OTN_COOKIE_FILE}";
	fi

	if [[ "${JVMW_DEBUG}" == "Y" ]]; then
		ls -laFh "${ARCHIVE_FILE}"
	fi
	#
	check_checksum
	local status=$?
	if [[ ${status} -ne 0 ]]; then
		die
	fi
}

function oracle_check_the_need_for_downloading() {
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

	oracle_otn_page_latest_version_jdk_page_parser

	if [[ ${ARCHIVE_JVM_URL} == *"${JVM_VERSION}"* ]] && [[ "${REQUIRED_UPDATE}" != "Y" ]]; then
		write_last_update
		return 0
	fi
}

function oracle_otn_page_latest_version_jdk_page_parser() {
	JVM_PAGE_URL=https://www.oracle.com$(curl -s https://www.oracle.com/technetwork/java/javase/downloads/index.html | awk 'match($0, /(\/technetwork\/java\/javase\/downloads\/jdk'"${JVM_VERSION_MAJOR}"'-downloads-[^\"]+)/) { print substr($0, RSTART, RLENGTH) }' | head -1)

	if [[ "${JVM_PAGE_URL}" != "https://www.oracle.com" ]]; then
		oracle_otn_page_archive_jdk_parser
		if [[ ! -z "${ARCHIVE_JVM_URL}" ]]; then
			return 0
		fi
	fi

	local -r url_archive=https://www.oracle.com$(curl -sS https://www.oracle.com/technetwork/java/javase/downloads/index.html | awk 'match($0, /(\/technetwork\/java\/javase\/archive-[^\"]+)/) { print substr($0, RSTART, RLENGTH) }' | head -1)

	JVM_PAGE_URL=https://www.oracle.com$(curl -sS "${url_archive}" | awk 'match($0, /(\/technetwork\/java\/javase\/downloads\/java-archive-[^'"${JVM_VERSION_MAJOR}"']+'"${JVM_VERSION_MAJOR}"'-[^\"]+)/) { print substr($0, RSTART, RLENGTH) }' 2>&1 | head -1)

	oracle_otn_page_archive_jdk_parser
}

function oracle_otn_page_archive_jdk_parser() {
	debug "JVM_PAGE_URL='${JVM_PAGE_URL}'"
	local -r content=$(curl -s "${JVM_PAGE_URL}")
	local awk_mask
	if [[ ${JVM_VERSION_MAJOR} -lt 9 ]]; then
		awk_mask='^downloads.*?jdk-'${JVM_VERSION_MAJOR}'u'${JVM_VERSION_UPDATE}'.*?-'${ARCH}'.*?.'${ARCHIVE_EXT}
	else
		awk_mask='^downloads.*?jdk-'${JVM_VERSION}'.*?-'${ARCH}'.*?.'${ARCHIVE_EXT}
	fi
	debug "awk_mask=${awk_mask}"

	# shellcheck disable=SC2034
	local -r separator='":"|", "|"}'
	# shellcheck disable=SC2086
	local -r row=$(echo "${content}" | awk '{ if (match($0, "'${awk_mask}'")) print }')

	IFS=',"' read -ra fields <<<"${row}"
	for i in "${!fields[@]}"; do
		case "${fields[$i]}" in
			filepath)
				ARCHIVE_JVM_URL="${fields[$i+2]}"
			;;
			SHA256)
				ARCHIVE_JVM_CHECKSUM="${fields[$i+2]}"
			;;
		esac
	done

	debug "ARCHIVE_JVM_URL='${ARCHIVE_JVM_URL}'"
}

# END SCRIPT
