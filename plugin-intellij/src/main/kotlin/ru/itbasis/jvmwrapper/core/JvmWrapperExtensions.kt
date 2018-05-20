package ru.itbasis.jvmwrapper.core

import java.lang.IllegalArgumentException

fun String.toBoolean() = when (this.toUpperCase()) {
  "Y" -> true
  "N" -> false
  else -> throw IllegalArgumentException("unknown value '$this' from parameter '${JvmWrapperPropertyKeys.JVM_REQUIRED_UPDATE}'")
}
