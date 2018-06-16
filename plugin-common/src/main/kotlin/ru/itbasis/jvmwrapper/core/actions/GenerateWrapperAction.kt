package ru.itbasis.jvmwrapper.core.actions

import ru.itbasis.jvmwrapper.core.JvmWrapper
import java.io.File
import java.io.FileOutputStream
import java.net.URL

class GenerateWrapperAction(private val parentDir: File) : Runnable {

  override fun run() {
    URL(JvmWrapper.REMOTE_SCRIPT_URL).openStream().copyTo(FileOutputStream(File(parentDir, "jvmw")))
  }
}
