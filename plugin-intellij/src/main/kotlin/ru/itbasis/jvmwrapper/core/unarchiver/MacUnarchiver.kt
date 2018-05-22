package ru.itbasis.jvmwrapper.core.unarchiver

import ru.itbasis.jvmwrapper.core.ProcessStepListener
import ru.itbasis.jvmwrapper.core.step
import java.io.File

class MacUnarchiver(sourceFile: File, targetDir: File, stepListener: ProcessStepListener? = null) :
  AbstractUnarchiver(sourceFile, targetDir, stepListener) {

  private var runtime = Runtime.getRuntime()
  private var fullName: String = sourceFile.nameWithoutExtension
  private var volumePath = "/Volumes/$fullName"

  init {
    unpack()
  }

  override fun unpack(removeOriginal: Boolean) {
    "Detaching a previously attached dmg archive".step(stepListener) { detach(quiet = true).run() }

    "Attaching the dmg archive".step(stepListener) { attach().run() }

    "Search for PKG file".step(stepListener) { findPkgFile() }.let { pkgFile ->

      "Unpacking the PKG file".step(stepListener) {
        unpackPkg(pkgFile).let { tempDir ->
          try {
            "Unpacking the CPIO file".step(stepListener) { unpackCpio(tempDir) }

            "Moving unpacked content".step(stepListener) { moveContent(tempDir) }
          } finally {
            tempDir.deleteRecursively()
          }
        }
      }
    }

    "Detaching a previously attached dmg archive...".step(stepListener) { detach().run() }
    "Removing source archive: ".step(stepListener) { sourceFile.delete() }
  }

  private fun unpackPkg(pkgFile: File) = createTempDir(suffix = fullName).apply {
    runtime.exec(
      arrayOf(
        "xar",
        "-xf",
        pkgFile.absolutePath,
        "."
      ), null, this
    ).run()
  }

  private fun unpackCpio(dir: File) {
    dir.listFiles { _, name -> name?.contains("jdk") ?: false }.forEach { jdkDir ->
      ProcessBuilder("cpio", "-i").redirectInput(jdkDir.resolve("Payload"))
        .directory(dir)
        .start()
        .run()
    }
  }

  private fun moveContent(dir: File) {
    dir.resolve("Contents").renameTo(targetDir)
  }

  private fun attach() = runtime.exec(
    arrayOf(
      CMD_HDIUTIL,
      "attach",
      sourceFile.absolutePath,
      "-mountpoint",
      volumePath
    )
  )

  private fun detach(quiet: Boolean = false) = runtime.exec(
    arrayOf(
      CMD_HDIUTIL,
      "detach",
      volumePath,
      "-force"
    ).apply {
      if (quiet) this.plus("-quiet")
    }
  )

  private fun findPkgFile() = File(volumePath).walkTopDown().find { it.extension == "pkg" }
    ?: throw IllegalStateException("package file not found in '$volumePath'")

  companion object {
    const val CMD_HDIUTIL = "hdiutil"

    @JvmStatic
    fun main(args: Array<String>) {
      val sourceFile = File("/Users/victor.alenkov/.jvm/jdk-10.0.1_osx-x64_bin.dmg")
      val targetDir = File("/Users/victor.alenkov/.jvm/oracle-jdk-10.0.1")
      MacUnarchiver(sourceFile, targetDir)
    }
  }
}
