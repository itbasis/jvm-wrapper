package ru.itbasis.jvm.wrapper

import java.io.File
import java.lang.System.getProperty
import java.nio.file.Path
import java.nio.file.Paths

class JvmWrapper(projectDirPath: Path) {

    var wrapperProperties: JvmWrapperProperties
        private set

    companion object {
        val HOME_DIR_PATH = arrayOf(getProperty("user.dir"), ".jvm").joinToString(File.separator)

        @JvmStatic
        var DEFAULT_PROPERTIES: JvmWrapperProperties = JvmWrapperProperties(vendor = JvmVendor.ORACLE, jvmType = JvmType.JDK, version = DEFAULT_JVM_VERSION, debug = false, oracleKeychainName = ORACLE_KEYCHAIN_DEFAULT_NAME)
    }

    init {
        wrapperProperties = JvmWrapperProperties().apply {
            append(Paths.get(HOME_DIR_PATH, JVMW_PROPERTY_FILE_NAME))
            append(Paths.get(projectDirPath.toString(), JVMW_PROPERTY_FILE_NAME))
            append(DEFAULT_PROPERTIES)
        }
    }

    fun getJdkHome(): Path {
        return Paths.get(HOME_DIR_PATH, "${wrapperProperties.vendor}-${wrapperProperties.type}-${wrapperProperties.version}")
    }
}