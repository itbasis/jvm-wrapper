package ru.itbasis.jvm.wrapper

import java.lang.IllegalArgumentException
import java.nio.file.Path
import java.util.Properties

enum class JvmWrapperPropertyKeys {
    JVM_VENDOR, JVM_TYPE, JVM_VERSION, JVMW_DEBUG, JVM_REQUIRED_UPDATE, JVMW_ORACLE_KEYCHAIN, ORACLE_USER, ORACLE_PASSWORD, JVMW_USE_SYSTEM_JDK
}

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

enum class JvmType {
    JVM, JDK;

    override fun toString(): String {
        return this.name.toLowerCase()
    }
}

const val DEFAULT_JVM_VERSION = "9"
const val JVMW_PROPERTY_FILE_NAME = "jvmw.properties"
const val ORACLE_KEYCHAIN_DEFAULT_NAME = "JVM_WRAPPER_ORACLE"

class JvmWrapperProperties(vendor: JvmVendor? = null, jvmType: JvmType? = null, version: String? = null, requiredUpdate: Boolean? = null, debug: Boolean? = null, useSystemJdk: Boolean? = null, oracleKeychainName: String? = null) {
    var vendor: JvmVendor? = vendor
        private set
    var type: JvmType? = jvmType
        private set
    var version: String? = version
        private set
    var requiredUpdate: Boolean? = requiredUpdate
        private set
    var debug: Boolean? = debug
        private set
    var useSystemJdk: Boolean? = useSystemJdk
        private set
    var oracleKeychainName: String? = oracleKeychainName
        private set

    fun append(propertyFilePath: Path? = null) {
        if (propertyFilePath == null || !propertyFilePath.toFile().isFile) {
            return
        }
        val properties = Properties()
        properties.load(propertyFilePath.toFile().inputStream())
        properties.forEach { (key, value) ->
            if (key !is String || value !is String) return

            when (key.toUpperCase()) {
                JvmWrapperPropertyKeys.JVM_VENDOR.name -> if (vendor == null) vendor = JvmVendor.parse(value)
                JvmWrapperPropertyKeys.JVM_TYPE.name -> if (type == null) type = JvmType.valueOf(value.toUpperCase())
                JvmWrapperPropertyKeys.JVM_VERSION.name -> if (version == null) version = value
                JvmWrapperPropertyKeys.JVM_REQUIRED_UPDATE.name -> if (requiredUpdate == null) requiredUpdate = value.toBoolean()
                JvmWrapperPropertyKeys.JVMW_DEBUG.name -> if (debug == null) debug = value.toBoolean()
                JvmWrapperPropertyKeys.JVMW_USE_SYSTEM_JDK.name -> if (useSystemJdk == null) useSystemJdk = value.toBoolean()
                JvmWrapperPropertyKeys.JVMW_ORACLE_KEYCHAIN.name -> if (oracleKeychainName == null) oracleKeychainName = value
            }
        }
    }

    fun append(jvmWrapperProperties: JvmWrapperProperties) {
        if (vendor == null) vendor = jvmWrapperProperties.vendor
        if (type == null) type = jvmWrapperProperties.type
        if (version == null) version = jvmWrapperProperties.version
        if (requiredUpdate == null) requiredUpdate = jvmWrapperProperties.requiredUpdate
        if (debug == null) debug = jvmWrapperProperties.debug
        if (useSystemJdk == null) useSystemJdk = jvmWrapperProperties.useSystemJdk
        if (oracleKeychainName == null) oracleKeychainName = jvmWrapperProperties.oracleKeychainName
    }
}