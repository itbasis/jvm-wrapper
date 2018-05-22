package ru.itbasis.jvmwrapper.core

import io.github.glytching.junit.extension.folder.TemporaryFolder
import io.github.glytching.junit.extension.folder.TemporaryFolderExtension
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Disabled
import org.junit.jupiter.api.Tag
import org.junit.jupiter.api.extension.ExtendWith
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ArgumentsSource
import ru.itbasis.jvmwrapper.core.vendor.JvmVersionSample
import ru.itbasis.jvmwrapper.core.vendor.JvmVersionSampleArgumentsProvider
import java.io.File
import java.math.BigDecimal
import java.math.RoundingMode
import java.nio.charset.Charset
import java.util.concurrent.TimeUnit

@Tag("large")
internal class JvmWrapperDefaultTest {
  private val stepListener: (String) -> Unit = { msg -> println(msg) }
  private val downloadProcessListener: (RemoteArchiveFile, Long, Long) -> Boolean = { _, sizeCurrent, sizeTotal ->
    val percentage = BigDecimal(sizeCurrent.toDouble() / sizeTotal * 100).setScale(2, RoundingMode.HALF_UP)
    println("$sizeCurrent / $sizeTotal :: $percentage%")
    true
  }

  @Disabled
  @ParameterizedTest
  @ExtendWith(TemporaryFolderExtension::class)
  @ArgumentsSource(value = JvmVersionSampleArgumentsProvider::class)
//  @ArgumentsSource(value = JvmVersionArchiveSampleArgumentsProvider::class)
  internal fun `test versions`(jvmVersionSample: JvmVersionSample, temporaryFolder: TemporaryFolder) {
    val propertiesFile = temporaryFolder.createFile("jvmw.properties").apply {
      appendText("JVM_VERSION=${jvmVersionSample.version}\n")
      appendText("JVM_VENDOR=${jvmVersionSample.vendor}")
    }
    val workingDir = propertiesFile.parentFile
    File(System.getProperty("user.dir")).parentFile.resolve(JvmWrapper.SCRIPT_FILE_NAME)
      .copyTo(File(workingDir, JvmWrapper.SCRIPT_FILE_NAME))

    val jvmWrapper = JvmWrapper(workingDir, stepListener = stepListener, downloadProcessListener = downloadProcessListener)
    val jvmHomeDir = jvmWrapper.jvmHomeDir
    println("jvmHomeDir: $jvmHomeDir")

    val jvmBinDir = jvmHomeDir.resolve("bin")
    assertTrue(jvmBinDir.exists(), "$jvmBinDir not exists")

    val process = ProcessBuilder(File(jvmBinDir, "java").absolutePath, "-fullversion").start()
    process.waitFor(5, TimeUnit.SECONDS)
    assertEquals(
      """java full version "${jvmVersionSample.fullVersion}"""",
      process.errorStream.readBytes().toString(Charset.defaultCharset()).trim()
    )
  }
}
