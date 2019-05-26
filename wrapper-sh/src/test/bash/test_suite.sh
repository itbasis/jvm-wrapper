#!/usr/bin/env bash

#ORIGIN_PWD=$PWD
# Hack for code verification
ENV_TEST_FILE=${ENV_TEST_FILE:?}

while IFS='' read -r line || [[ -n "$line" ]]; do
	eval "export ${line}" 1> /dev/null
done <"samples.properties/${ENV_TEST_FILE}.env"

# shellcheck disable=SC1090
#source "./test.env/$ENV_TEST_FILE.env"

# Hack for code verification
TEST_TYPE=${TEST_TYPE:?}
TEST_FULL_VERSION=${TEST_FULL_VERSION:?}
TEST_REUSE_JAVA_VERSION=${TEST_REUSE_JAVA_VERSION}
#

shellcheck builder.bash
bash builder.bash
build/jvmw java -fullversion
build/jvmw java -version
bats -p src/test/bash/jvmw.bats && bats -p src/test/bash/part_*.bats
