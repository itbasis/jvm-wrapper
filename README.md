# JDK Wrapper

[![Build Status](https://travis-ci.org/itbasis/jvm-wrapper.svg?branch=master)](https://travis-ci.org/itbasis/jvm-wrapper)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](/LICENSE)
[![Powered By: Victor Alenkov](https://img.shields.io/badge/powered%20by-Victor%20Alenkov-green.svg?style=flat-square)](https://github.com/BorzdeG)

![Support Linux](https://img.shields.io/badge/support%20OS-Linux-green.svg?style=flat-square)
![Support Mac OS](https://img.shields.io/badge/support%20OS-Mac%20OS-green.svg?style=flat-square)

![Support JDK](https://img.shields.io/badge/support%20JDK-9-green.svg?style=flat-square)
![Support JDK](https://img.shields.io/badge/support%20JDK-8-green.svg?style=flat-square)
![Support JDK](https://img.shields.io/badge/support%20JDK-7-green.svg?style=flat-square)

## Install

download file `jdkw` in `~/.jvm/` or project directory

## Usage
`./jdkw java commands` or `~/.jvm/jdkw java commands`

`./jdkw javac commands` or `~/.jvm/jdkw javac commands`

Instead of `java` or `javac`, you can use any command from `$JAVA_HOME/bin/`

## Properties
Order of reading variables: environment, `~/jvmw.properties`, `./jvmw.properties`. The last read value is set for the variable

Properties are read without replacing the previously read. For example, if environment does not have an empty `JDK_VERSION_MAJOR` variable and also has `./jvmw.properties`, then the variable from the environment

To download archival versions of JDK, you must set the variables `ORACLE_USER` and `ORACLE_PASSWORD`

#### jvmw.properties

|property name|sample|
|---|---|
|JDK_VERSION|JDK_VERSION=9<br/>JDK_VERSION=8<br/>JDK_VERSION=8u144|
|JDK_VERSION_MAJOR|JDK_VERSION_MAJOR=8<br/>JDK_VERSION_MAJOR=9|
|JDK_VERSION_MINOR|JDK_VERSION_MINOR=<br/>JDK_VERSION_MINOR=144<br/>JDK_VERSION_MINOR=80|
|ORACLE_USER|ORACLE_USER=user@example.com|
|ORACLE_PASSWORD|ORACLE_PASSWORD=password|

\* The `JDK_VERSION` variable takes precedence over `JDK_VERSION_MAJOR` and `JDK_VERSION_MINOR`.

[sample configuration files](samples)
