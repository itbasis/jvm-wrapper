package ru.itbasis.jvmwrapper.core.vendor

import java.lang.IllegalArgumentException

enum class JvmVendor(val code: String) {
  ORACLE("oracle"), OPEN_JDK("openjdk");

  companion object {
    fun parse(code: String?): JvmVendor? {
      if (code == null) return null

      for (item in values()) {
        if (item.code.equals(code, ignoreCase = true)) return item
      }
      throw IllegalArgumentException("value '$code' unsupported")
    }
  }
}
