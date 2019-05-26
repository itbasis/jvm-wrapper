#!/usr/bin/env bash

# Shellcheck
scversion="latest"
wget "https://storage.googleapis.com/shellcheck/shellcheck-${scversion}.linux.x86_64.tar.xz"
tar --xz -xvf shellcheck-"${scversion}".linux.x86_64.tar.xz
cp shellcheck-"${scversion}"/shellcheck /usr/bin/
shellcheck --version

# Bats
mkdir -p /opt/bats && cd /opt/bats && git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh /usr/local
bats -v

#
cd /opt/jvmw-prj && ./src/test/bash/test_suite.sh 2>&1
