#!/usr/bin/env bash

unset USE_SYSTEM_JDK JVMW_DEBUG REQUIRED_UPDATE
for env_test in $(env | grep TEST_); do
	unset "${env_test%%=*}"
done