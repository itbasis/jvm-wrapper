package ru.itbasis.plugins.intellij.jvmwrapper

import com.intellij.openapi.util.SystemInfo
import org.apache.commons.lang3.SystemUtils
import java.io.File

class JvmWrapper(projectDir: File) {

  private lateinit var wrapperProperties: JvmWrapperProperties

  val homeDir: File by lazy { SystemUtils.getUserHome().resolve(".jvm") }

  val sdkName: String by lazy { "$SCRIPT_FILE_NAME-$jdkName" }

  val jdkName: String by lazy { "${wrapperProperties.vendor}-${wrapperProperties.type}-${wrapperProperties.version}".toLowerCase() }

  val jdkHomeDir: File by lazy { homeDir.resolve(jdkName).resolve(if (SystemInfo.isMac) "Home" else "") }

  companion object {
    const val SCRIPT_FILE_NAME = "jvmw"

    @JvmStatic
    var DEFAULT_PROPERTIES: JvmWrapperProperties =
      JvmWrapperProperties(
        vendor = JvmVendor.ORACLE,
        jvmType = JvmType.JDK,
        version = DEFAULT_JVM_VERSION,
        debug = false,
        oracleKeychainName = ORACLE_KEYCHAIN_DEFAULT_NAME
      )
  }

  init {
    wrapperProperties = JvmWrapperProperties().apply {
      append(homeDir.resolve(JVMW_PROPERTY_FILE_NAME))
      append(projectDir.resolve(JVMW_PROPERTY_FILE_NAME))
      append(DEFAULT_PROPERTIES)
    }
  }
}
