package ru.itbasis.jvmwrapper.core

object SystemInfo {
  private val OS_NAME = System.getProperty("os.name")
  private val ARCH_DATA_MODEL = System.getProperty("sun.arch.data.model").toLowerCase()
  //
  val is32Bit = ARCH_DATA_MODEL == "32"

  val IS_OS_LINUX = OS_NAME.startsWith(prefix = "Linux", ignoreCase = true)
  val IS_OS_MAC = OS_NAME.startsWith(prefix = "Mac", ignoreCase = true)

  val isSupportedOS = IS_OS_LINUX || IS_OS_MAC

  val NEW_LINE = "\n"
}
