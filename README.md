# JDK Wrapper

[![Build Status](https://travis-ci.org/itbasis/jvm-wrapper.svg?branch=master)](https://travis-ci.org/itbasis/jvm-wrapper)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](/LICENSE)
[![Powered By: Victor Alenkov](https://img.shields.io/badge/powered%20by-Victor%20Alenkov-green.svg?style=flat-square)](https://github.com/BorzdeG)

![Support Linux](https://img.shields.io/badge/support%20OS-Linux-green.svg?style=flat-square)
![Support Mac OS](https://img.shields.io/badge/support%20OS-Mac%20OS-green.svg?style=flat-square)

## Usage
`./jdkw java command`

`./jdkw javac command`

## properties
reading order: ENVIRONMENT, `~/jvmw.properties`, `./jvmw.properties`

Properties are read without replacing the previously read. For example, if ENVIRONMENT does not have an empty `JDK_FAMILY` variable and also has `./jvmw.properties`, then the variable from the ENVIRONMENT