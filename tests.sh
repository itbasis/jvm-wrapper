#!/usr/bin/env bash

JVMW=${1:-./jdkw}
JVMW_FILE=${JVMW_FILE}
JDK_FAMILY=${JDK_FAMILY}
CHECK_JDK_VERSION=${CHECK_JDK_VERSION}

#
function check_output() {
	# shellcheck disable=SC2086
	output=$("${JVMW}" $1 2>&1)
	if [[ "${output}" != *"$2"* ]]; then
		>&2 echo --- check \'"$1"\' contains \'"$2"\' ---
		echo --- capture output :: begin ---
		echo "${output}"
		echo --- capture output :: end ---
		exit 1
	fi
}

#
if [ -f "samples/${JVMW_FILE}" ]; then
	cp "samples/${JVMW_FILE}" jvmw.properties
else
	touch jvmw.properties
fi

#
check_output 'javac -version' "${CHECK_JDK_VERSION}"
check_output 'java -version' "${CHECK_JDK_VERSION}"

#
mkdir -p ./build/test
cmd='javac -d ./build/test test/Test.java'
# shellcheck disable=SC2086
output=$("${JVMW}" ${cmd} 2>&1)
if [ -n "${output}" ]; then
	>&2 echo --- check \'"${cmd}"\' ---
	echo --- capture output :: begin ---
	echo "${output}"
	echo --- capture output :: end ---
	exit 1
fi

check_output 'java -cp ./build/test/ Test' "${CHECK_JDK_VERSION}"
rm -Rf ./build/test/