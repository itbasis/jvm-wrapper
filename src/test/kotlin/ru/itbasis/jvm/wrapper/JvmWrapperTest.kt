package ru.itbasis.jvm.wrapper

import io.github.glytching.junit.extension.folder.TemporaryFolder
import io.github.glytching.junit.extension.folder.TemporaryFolderExtension
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertFalse
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith

class JvmWrapperDefaultTest {
    @Test
    fun testDefaultProperties() {
        val jvmWrapperProperties = JvmWrapper.DEFAULT_PROPERTIES

        assertEquals(JvmVendor.ORACLE, jvmWrapperProperties.vendor)
        assertEquals(DEFAULT_JVM_VERSION, jvmWrapperProperties.version)
        assertNull(jvmWrapperProperties.requiredUpdate)
        assertNotNull(jvmWrapperProperties.debug)
        assertFalse(jvmWrapperProperties.debug!!)
        assertNull(jvmWrapperProperties.useSystemJdk)
        assertEquals(ORACLE_KEYCHAIN_DEFAULT_NAME, jvmWrapperProperties.oracleKeychainName)
    }

    @Test
    @ExtendWith(TemporaryFolderExtension::class)
    fun testDefaultWrapper(temporaryFolder: TemporaryFolder) {
        val testProjectFolder = temporaryFolder.createDirectory("jvm-wrapper")
        val jvmWrapper = JvmWrapper(testProjectFolder.toPath())
        val jvmWrapperProperties = jvmWrapper.wrapperProperties

        assertEquals(JvmVendor.ORACLE, jvmWrapperProperties.vendor)
        assertEquals(DEFAULT_JVM_VERSION, jvmWrapperProperties.version)
        assertNull(jvmWrapperProperties.requiredUpdate)
        assertNotNull(jvmWrapperProperties.debug)
        assertFalse(jvmWrapperProperties.debug!!)
        assertNull(jvmWrapperProperties.useSystemJdk)
        assertEquals(ORACLE_KEYCHAIN_DEFAULT_NAME, jvmWrapperProperties.oracleKeychainName)
    }
}