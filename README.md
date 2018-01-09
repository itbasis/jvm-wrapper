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

## properties
Order of reading variables: environment, `~/jvmw.properties`, `./jvmw.properties`. The last read value is set for the variable

Properties are read without replacing the previously read. For example, if environment does not have an empty `JDK_FAMILY` variable and also has `./jvmw.properties`, then the variable from the environment

To download archival versions of JDK, you must set the variables `ORACLE_USER` and `ORACLE_PASSWORD`

#### jvmw.properties
|property name|required|sample|
|:---|:---:|:---|
|JDK_FAMILY|Y|JDK_FAMILY=8<br/>JDK_FAMILY=9|
|JDK_UPDATE_VERSION|N|JDK_UPDATE_VERSION=<br/>JDK_UPDATE_VERSION=144<br/>JDK_UPDATE_VERSION=80|
|ORACLE_USER|N|ORACLE_USER=user@example.com|
|ORACLE_PASSWORD|N|ORACLE_PASSWORD=password|
