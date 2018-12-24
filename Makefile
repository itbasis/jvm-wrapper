WORKING_DIR=$(shell echo "`pwd`")
JVM_WRAPPER_VERSION?=$(shell echo "`date +%Y%m%d_%H%M%S`")
ENV_TEST_FILE?=openjdk-8

include samples.properties/$(ENV_TEST_FILE).env

export JVM_WRAPPER_VERSION
export ENV_TEST_FILE

prepare_core:
	env
	@echo "WORKING_DIR=$(WORKING_DIR)"
	echo "$(JVM_WRAPPER_VERSION)" > $(WORKING_DIR)/version.txt

prepare_sh: prepare_core
	bats -v
	shellcheck -V

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
