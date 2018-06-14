package ru.itbasis.jvmwrapper.core

import org.apache.commons.lang3.SystemUtils
import org.apache.commons.lang3.SystemUtils.IS_OS_MAC
import ru.itbasis.jvmwrapper.core.unarchiver.MacUnarchiver
import ru.itbasis.jvmwrapper.core.vendor.DownloadProcessListener
import ru.itbasis.jvmwrapper.core.vendor.JvmVendor
import ru.itbasis.jvmwrapper.core.vendor.OracleProvider
import java.io.File

class JvmWrapper(
  private val workingDir: File,
  private val downloadProcessListener: DownloadProcessListener? = null,
  private val stepListener: ProcessStepListener? = null
) {
  init {
    require(workingDir.isDirectory) { "'$workingDir' is not a directory" }
  }

  private val homeDir: File = File(SystemUtils.USER_HOME, ".jvm")

  private val wrapperProperties: JvmWrapperProperties = JvmWrapperProperties().apply {
    "Reading properties from the working directory".step(stepListener) { workingDir.resolve(JVMW_PROPERTY_FILE_NAME).let { append(it) } }
    "Reading properties from the shared directory".step(stepListener) { homeDir.resolve(JVMW_PROPERTY_FILE_NAME).let { append(it) } }
    "Adding default properties".step(stepListener) { append(DEFAULT_PROPERTIES) }
  }

  val jvmName: String = "${wrapperProperties.vendor}-${wrapperProperties.type}-${wrapperProperties.version}".toLowerCase()

  val jvmHomeDir: File = homeDir.resolve(jvmName).also { jvmHomeDir ->
    "check exists jvm home directory: $jvmHomeDir".step(stepListener) {
      if (jvmHomeDir.isDirectory) return@step
      "download jvm archive...".step(stepListener) {
        val jvmVersion = JvmVersion(type = wrapperProperties.type!!, version = wrapperProperties.version!!)
        val provider = OracleProvider(jvmVersion = jvmVersion)
        val remoteFile = "specifying the URL for the JVM archive...".step(stepListener) { provider.remoteArchiveFile }

        "download remote archive: ${remoteFile.url}".step(stepListener) {
          File(homeDir, "$jvmName.${provider.archiveExtension}").apply {
            provider.download(remoteArchiveFile = remoteFile, target = this, downloadProcessListener = downloadProcessListener)
          }
        }
      }.let { archiveFile -> "unpack JVM archive file".step(stepListener) { MacUnarchiver(archiveFile, jvmHomeDir, stepListener) } }
    }
  }.run { if (IS_OS_MAC) this.resolve("Home") else this }.apply { check(isDirectory, { "jvm home directory is not exists: $this" }) }

  companion object {
    const val SCRIPT_FILE_NAME = "jvmw"
    const val JVMW_PROPERTY_FILE_NAME = "$SCRIPT_FILE_NAME.properties"
    val DEFAULT_PROPERTIES: JvmWrapperProperties = JvmWrapperProperties(
      vendor = JvmVendor.ORACLE,
      jvmType = JvmType.JDK,
      version = DEFAULT_JVM_VERSION,
      debug = false,
      oracleKeychainName = ORACLE_KEYCHAIN_DEFAULT_NAME
    )
  }
}
