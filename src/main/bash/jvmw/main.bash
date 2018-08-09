#!/usr/bin/env bash

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
		if [[ "${JVMW_DEBUG}" == "Y" ]]; then
			ls -laFh "${ARCHIVE_FILE}"
		fi
		if [[ ${JVM_VERSION_MAJOR} -lt 8 ]]; then
			# TODO
			rm -f "${ARCHIVE_FILE}"
		elif check_checksum; then
			eval "${JVM_VENDOR}_unpack_${OS}"
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
	eval "${JVM_VENDOR}_unpack_${OS}"

	write_last_update
}

function main_properties() {
	[[ -f "${JVMW_HOME}/${JVMW_PROPERTY_FILE}" ]] && { properties_parser "$(cat "${JVMW_HOME}/${JVMW_PROPERTY_FILE}")"; }
	[[ -f "${JVMW_PROPERTY_FILE}" ]] && { properties_parser "$(cat "${JVMW_PROPERTY_FILE}")"; }
	properties_parser "$(properties_default)"
	properties_build
}

function check_is_out_of_date() {
	REQUIRED_UPDATE=N
	if [[ ! -f "${LAST_UPDATE_FILE}" ]]; then
		debug "not found file: '${LAST_UPDATE_FILE}'"
		REQUIRED_UPDATE=Y
	else
		local -r luf_date="$(head -1 <"${LAST_UPDATE_FILE}")"
		# shellcheck disable=SC2005
		local -r prev_date=$([[ "${OS}" == "darwin" ]] && echo "$(date -jf '%F %R' "${luf_date}" +%j)" || echo "$(date --date="${luf_date}" '+%j')")
		local -r curr_date=$(date +%j)
		debug "prev_date='${prev_date}', curr_date='${curr_date}'"
		if [[ ${curr_date} > ${prev_date} ]]; then
			REQUIRED_UPDATE=Y
		fi
	fi
	return 0
}

function detect_system_jdk() {
	local -r cmd="javac"
	cmd_path=$(whereis "${cmd}")

	if [[ -z "${cmd_path}" ]]; then
		USE_SYSTEM_JVM=N
		return 0
	fi

	ls_output="$(ls -l "${cmd_path}")"
	while [[ "${ls_output}" == *"${cmd_path} "* ]]; do
		cmd_path="$(readlink "${cmd_path}")"
		ls_output="$(ls -l "${cmd_path}")"
	done

	jvm_dir=$(dirname "${cmd_path}")
	if [[ -f "${jvm_dir}/java_home" ]]; then
		jvm_dir=$("${jvm_dir}/java_home" 2>&1)
	fi

	if [[ -z "${jvm_dir}" ]] || [[ "${jvm_dir}" == *"Unable to find any JVMs matching version"* ]]; then
		USE_SYSTEM_JVM=N
		return 0
	fi

	local -r jdk_output="$(java -XshowSettings:properties -version 2>&1)"
	if [[ "${jdk_output}" == *"command not found"* ]]; then
		USE_SYSTEM_JVM=N
		return 0
	fi

	if [[ "${jdk_output}" != *"java.runtime.version = ${JVM_VERSION_MAJOR}."* ]] && [[ "${jdk_output}" != *"java.runtime.version = 1.${JVM_VERSION_MAJOR}."* ]] && [[ "${jdk_output}" != *"java.runtime.version = ${JVM_VERSION_MAJOR}+"* ]]; then
		USE_SYSTEM_JVM=N
		return 0
	fi

	USE_SYSTEM_JVM=Y
	eval "JDK_HOME_DIR='${jvm_dir}/'"

	return 0
}

function detect_reuse_jdk() {
	if [[ -z "${JVM_VERSION_UPDATE}" ]]; then
		return 0;
	fi
	local -r jvm_root_dir=${JVMW_HOME}/${JVM_VENDOR}-jdk-${JVM_VERSION_MAJOR}/$([[ "${OS}" == 'darwin' ]] && echo 'Home/')
	if [[ ! -d "${jvm_root_dir}" ]]; then
		return 0;
	fi
	local -r jdk_output="$("${jvm_root_dir}/bin/java" -fullversion 2>&1)"

	if [[ "${jdk_output}" != *"java full version \"${JVM_VERSION_MAJOR}.0.${JVM_VERSION_UPDATE}+"* ]] && [[ "${jdk_output}" != *"java full version \"1.${JVM_VERSION_MAJOR}.0_${JVM_VERSION_UPDATE}-"* ]] && [[ "${jdk_output}" != *"java full version \"${JVM_VERSION_MAJOR}+"* ]]; then
		return 0
	fi

	JVM_FULL_NAME="${JVM_VENDOR}-jdk-${JVM_VERSION_MAJOR}"
	JDK_ROOT_DIR=${JVMW_HOME}/${JVM_FULL_NAME}
	JDK_HOME_DIR=${JDK_ROOT_DIR}/$([[ "${OS}" == 'darwin' ]] && echo 'Home/')
	REQUIRED_UPDATE=N

	return 0
}

if [[ "${OS}" == "darwin" ]]; then
	system_check_program_exists "${REQUIRED_COMMANDS_CORE}" "${REQUIRED_COMMANDS_DARWIN}"
else
	system_check_program_exists "${REQUIRED_COMMANDS_CORE}" "${REQUIRED_COMMANDS_LINUX}"
fi

if [[ "$1" == "upgrade" ]]; then
	curl -sS https://raw.githubusercontent.com/itbasis/jvm-wrapper/master/jvmw >"$0"
	exit 0
fi

main_properties
detect_reuse_jdk
if [[ "${USE_SYSTEM_JVM}" == "Y" ]]; then
	detect_system_jdk
fi

if [[ "${USE_SYSTEM_JVM}" -eq "Y" ]]; then
	JVM_HOME_DIR="${JDK_HOME_DIR}"
fi

export JDK_HOME=${JDK_HOME_DIR%%/bin/*}
export JAVA_HOME=${JVM_HOME_DIR%%/bin/*}

if [[ -z "$1" ]] || [[ "$1" == "info" ]]; then
	print_debug_info
	echo "JDK_HOME=${JDK_HOME}"
	echo "JAVA_HOME=${JAVA_HOME}"

else
	download_jdk

	if [[ -z "${JVM_HOME_DIR}" ]]; then
		die "can't JVM_HOME_DIR"
	fi

	print_debug_info

	if [[ "$1" == "javac" ]] && [[ "${USE_SYSTEM_JVM}" != "Y" ]]; then
		PATH=.:${JDK_HOME}/bin:$PATH
		EXEC_PATH=${JDK_HOME}/bin/$1
	elif [[ "$1" == "java" ]] && [[ "${USE_SYSTEM_JVM}" != "Y" ]]; then
		PATH=.:${JAVA_HOME}/bin:$PATH
		EXEC_PATH=${JDK_HOME}/bin/$1
	else
		PATH=.:$PATH
		if [[ "${1:0:2}" == "./" ]]; then
			EXEC_PATH="$1"
		else
			EXEC_PATH=$(whereis "$1")
		fi
	fi

	if [[ -z "${EXEC_PATH}" ]]; then
		die "No program found to execute: $1"
	fi

	# execute program
	debug "command: ${EXEC_PATH}" "${@:2}"
	eval "${EXEC_PATH}" "${@:2}"
fi
# END SCRIPT
