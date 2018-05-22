package ru.itbasis.jvmwrapper.core.unarchiver

import ru.itbasis.jvmwrapper.core.ProcessStepListener
import java.io.File
import java.util.concurrent.TimeUnit

abstract class AbstractUnarchiver(
  protected val sourceFile: File,
  protected val targetDir: File,
  protected val stepListener: ProcessStepListener? = null
) {
  protected abstract fun unpack(removeOriginal: Boolean = false)

  protected fun Process.run() {
    this.waitFor(10, TimeUnit.SECONDS)
//    process.inputStream.copyTo(System.out)
//    process.errorStream.copyTo(System.out)
  }
}
