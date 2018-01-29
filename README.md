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

download file [jdkw](jdkw) in `~/.jvm/` or project directory

## Usage
`./jdkw java commands` or `~/.jvm/jdkw java commands`

`./jdkw javac commands` or `~/.jvm/jdkw javac commands`

Instead of `java` or `javac`, you can use any command from `$JAVA_HOME/bin/`

## Properties
Order of reading variables: environment, `~/jvmw.properties`, `./jvmw.properties`. The last read value is set for the variable

#### jvmw.properties

|property name|default|examples||
|---|:---:|---|---|
|JVM_VERSION| |[see examples of configuration files](samples.properties)||
|ORACLE_USER| |ORACLE_USER=user@example.com|
|ORACLE_PASSWORD| |ORACLE_PASSWORD=password|
|JVMW_DEBUG|`N`|`Y`, `N`|If `JVMW_DEBUG`=`Y`, debugging information will be displayed in stderr|
|REQUIRED_UPDATE|`Y`|`Y`, `N`|If `REQUIRED_UPDATE`=`N`, then an attempt will not be made to load the JDK / JVM distributor. If the required version of JDK/JVM is not found locally, an error will be generated<br/>If `REQUIRED_UPDATE`=`Y` and the required version is not locally found, an attempt will be made to download the distribution from the Oracle website

Properties are read without replacing the previously read. For example, if environment does not have an empty `JVM_VERSION` variable and also has `./jvmw.properties`, then the variable from the environment

To download archival versions of JDK, you must set the variables `ORACLE_USER` and `ORACLE_PASSWORD`

