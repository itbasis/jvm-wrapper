# JVM Wrapper

[![Build Status](https://travis-ci.org/itbasis/jvm-wrapper.svg?branch=master)](https://travis-ci.org/itbasis/jvm-wrapper)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](/LICENSE)
[![Powered By: Victor Alenkov](https://img.shields.io/badge/powered%20by-Victor%20Alenkov-green.svg?style=flat-square)](https://github.com/BorzdeG)

![Support Linux](https://img.shields.io/badge/support%20OS-Linux-green.svg?style=flat-square)
![Support Mac OS](https://img.shields.io/badge/support%20OS-Mac%20OS-green.svg?style=flat-square)

![Support Oracle JDK 10](https://img.shields.io/badge/support%20Oracle%20JDK-10-green.svg?style=flat-square)
![Support Oracle JDK 9](https://img.shields.io/badge/support%20Oracle%20JDK-9-green.svg?style=flat-square)
![Support Oracle JDK 8](https://img.shields.io/badge/support%20Oracle%20JDK-8-green.svg?style=flat-square)

## Install

download file [jvmw](jvmw) in `~/.jvm/` or project directory

## Usage

|command line|Description|
|---|---|
|`./jvmw jvm_wrapper_commands` or `~/.jvm/jvmw jvm_wrapper_commands`|Execute the internal JVM Wrapper commands. This does not check and update the JVM|
|`./jvmw java arguments` or `~/.jvm/jvmw java arguments`|Running JVM commands. In this case, the computed JVM Wrapper path is used as the path. Currently, only the `java` and `javac` commands are supported|
|`./jvmw command arguments` or `~/.jvm/jvmw command arguments`<br/>`./jvmw ./command arguments` or `~/.jvm/jvmw ./command arguments`|Running external commands |

Instead of `java` or `javac`, you can use any command from `$JAVA_HOME/bin/`

## JVM Wrapper Commands

|command|description|
|---|---|
|`info` or empty|Prints information about paths to `JDK_HOME`, `JAVA_HOME`|
|`upgrade`|Update JVM Wrapper with GitHub. Updating the running script (self-update)|

## Properties
Order of reading variables: environment, `~/jvmw.properties`, `./jvmw.properties`. The last read value is set for the variable

#### jvmw.properties

|property name|default|examples|description|
|---|:---:|---|---|
|JVM_VERSION| |[see examples of configuration files](samples.properties)||
|JVM_VENDOR| |`oracle`|`oracle` = [Oracle Site](http://www.oracle.com/technetwork/java/javase/downloads/index.html)||
|JVMW_ORACLE_KEYCHAIN|JVM_WRAPPER_ORACLE|Specifies the name of the Keychain Item, which stores the login (`ORACLE_USER`) and password (`ORACLE_PASSWORD`)|
|ORACLE_USER| |ORACLE_USER=user@example.com|
|ORACLE_PASSWORD| |ORACLE_PASSWORD=password|Value in the clear. It is recommended to use Keychain. If the parameter is not specified and the parameter `JVMW_ORACLE_KEYCHAIN` is not specified, an attempt will be made to find the password in Keychain by the parameter `ORACLE_USER`|
|JVMW_DEBUG|`N`|`Y`, `N`|If `JVMW_DEBUG`=`Y`, debugging information will be displayed in stderr|
|REQUIRED_UPDATE|`Y`|`Y`, `N`|If `REQUIRED_UPDATE`=`N`, then an attempt will not be made to load the JDK / JVM distributor. If the required version of JDK/JVM is not found locally, an error will be generated<br/>If `REQUIRED_UPDATE`=`Y` and the required version is not locally found, an attempt will be made to download the distribution from the Oracle website
|USE_SYSTEM_JVM|`Y`|`Y`, `N`|If the requested version of JDK is present in the system, then it will be used. If you want to explicitly specify that the system JDK is not used, you must specify `USE_SYSTEM_JVM=N`|

Properties are read without replacing the previously read. For example, if environment does not have an empty `JVM_VERSION` variable and also has `./jvmw.properties`, then the variable from the environment

To download archival versions of JDK, you must set the variables `ORACLE_USER` and `ORACLE_PASSWORD`

## IDE supports

[IDE plugins](https://github.com/itbasis/jvm-wrapper-ide-plugins/)
