#!/usr/bin/env bash

#ORIGIN_PWD=$PWD
# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}

while read -r line; do
	envName=$(sed 's/=.*$//' <<<"${line}")
	envValue=$(sed -E 's/^[^=]+=//' <<<"${line}")
	# shellcheck disable=SC2086
	export ${envName}=${envValue}
done < <( grep -E -v '^\s*(#|$)' "samples.properties/.env.${ENV_TEST_FILE}")

# shellcheck disable=SC1090
#source "./test.env/.env.$ENV_TEST_FILE"

# Hack for code verification
TEST_TYPE=${TEST_TYPE:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
TEST_REUSE_JAVA_VERSION=${TEST_REUSE_JAVA_VERSION}
JVMW_DEBUG=${JVMW_DEBUG:Y}
#

shellcheck builder.bash
bash builder.bash
build/jvmw java -fullversion
build/jvmw java -version
bats -p src/test/bash/jvmw.bats && bats -p src/test/bash/part_*.bats
