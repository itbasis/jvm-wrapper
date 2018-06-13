package ru.itbasis.jvmwrapper.core

import ru.itbasis.jvmwrapper.core.SystemInfo.isMac
import ru.itbasis.jvmwrapper.core.SystemInfo.isWindows

data class JvmVersion(val type: JvmType = JvmType.JDK, val version: String) {
  val major: String
    get() {
      return version.substringBefore("_").substringBefore("u").substringAfter("1.").substringBefore(".")
    }

  val update: String?
    get() {
      return if (version.contains("u") or version.contains("_")) version.substringAfter("_").substringAfter("u").substringAfterLast(".").substringBefore(
        "-"
      ) else null
    }

  val os: String
    get() {
      return when {
        isMac -> if (major.toInt() > 8) "osx" else "macosx"
        isWindows -> "windows"
        else -> "linux"
      }
    }

  override fun toString(): String = "JvmVersion($type-$version)"
}
