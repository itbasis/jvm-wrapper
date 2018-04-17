//package ru.itbasis.plugins.intellij.jvmwrapper
//
//import io.github.glytching.junit.extension.folder.TemporaryFolder
//import io.github.glytching.junit.extension.folder.TemporaryFolderExtension
//import org.junit.jupiter.api.Assertions.assertEquals
//import org.junit.jupiter.api.Assertions.assertFalse
//import org.junit.jupiter.api.Assertions.assertNotNull
//import org.junit.jupiter.api.Assertions.assertNull
//import org.junit.jupiter.api.extension.ExtendWith
//import org.junit.jupiter.params.ParameterizedTest
//import org.junit.jupiter.params.provider.ArgumentsSource
//import java.nio.file.Paths
//
//class JvmWrapperVersionsTest {
//
//  @ParameterizedTest
//  @ArgumentsSource(TestVersionArguments::class)
////    @MethodSource("data")
//  @ExtendWith(TemporaryFolderExtension::class)
//  fun testDefaultWrapper(testVersion: TestVersion, temporaryFolder: TemporaryFolder) {
//    val samplePropertiesFile = Paths.get("../samples.properties", "${testVersion.jvmVendor}-${testVersion.jvmVersion}.properties").toFile()
//      .copyTo(temporaryFolder.createFile(JVMW_PROPERTY_FILE_NAME), true)
//
//    val jvmWrapper = JvmWrapper(samplePropertiesFile.parentFile.toPath())
//    val jvmWrapperProperties = jvmWrapper.wrapperProperties
//
//    assertEquals(JvmVendor.ORACLE, jvmWrapperProperties.vendor)
//    assertEquals(JvmType.valueOf(testVersion.jvmType.toUpperCase()), jvmWrapperProperties.type)
//    assertEquals(testVersion.jvmVersion, jvmWrapperProperties.version)
//    assertNull(jvmWrapperProperties.requiredUpdate)
//    assertNotNull(jvmWrapperProperties.debug)
//    assertFalse(jvmWrapperProperties.debug!!)
//    assertNull(jvmWrapperProperties.useSystemJdk)
//    assertEquals(ORACLE_KEYCHAIN_DEFAULT_NAME, jvmWrapperProperties.oracleKeychainName)
//  }
//}
