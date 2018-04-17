package ru.itbasis.plugins.intellij.jvmwrapper

import java.lang.IllegalArgumentException

fun String.toBoolean(): Boolean {
    return when (this.toUpperCase()) {
        "Y" -> true
        "N" -> false
        else -> throw IllegalArgumentException("unknown value '$this' from parameter '${JvmWrapperPropertyKeys.JVM_REQUIRED_UPDATE}'")
    }
}
