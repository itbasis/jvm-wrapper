package ru.itbasis.jvmwrapper.core

import java.io.File

object SystemInfo {
  private val OS_NAME = System.getProperty("os.name")
  private val ARCH_DATA_MODEL = System.getProperty("sun.arch.data.model")
  //
  val isMac: Boolean = OS_NAME.startsWith("mac")
  val isLinux: Boolean = OS_NAME.startsWith("linux")
  val isWindows: Boolean = OS_NAME.startsWith("windows")
  //
  val is32Bit = ARCH_DATA_MODEL?.equals("32") ?: true
  val is64Bit = !is32Bit
  //
  val userHome: File = File(System.getProperty("user.home"))
}
