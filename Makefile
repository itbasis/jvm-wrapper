MAKEFILE_PATH=$(abspath $(lastword $(MAKEFILE_LIST)))
WORKING_DIR=$(dir $(MAKEFILE_PATH))
JVM_WRAPPER_VERSION?=$(shell echo "`date +%Y%m%d_%H%M%S`")
ENV_TEST_FILE?=openjdk-8_jdk

export JVM_WRAPPER_VERSION
export ENV_TEST_FILE

prepare_core:
	echo "$(JVM_WRAPPER_VERSION)" > $(WORKING_DIR)/version.txt

prepare_sh: prepare_core
	bats -v
	shellcheck -V
	@echo "WORKING_DIR=$(WORKING_DIR)"

build_sh: prepare_sh
	cd wrapper-sh && \
	shellcheck builder.bash && \
	bash builder.bash

check_sh: build_sh
	cd wrapper-sh && \
	bats -p src/test/bash/jvmw.bats && \
	bats -p src/test/bash/jvmw/*.bats

prepare_plugin: check_sh
	cp wrapper-sh/build/jvmw ./
