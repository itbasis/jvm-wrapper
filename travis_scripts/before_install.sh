#!/usr/bin/env bash

travis_retry brew update \
&& travis_retry brew install shellcheck \
&& travis_retry python2 -m pip install pycodestyle \
&& exit 0