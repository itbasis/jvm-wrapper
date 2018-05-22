package ru.itbasis.jvmwrapper.core.vendor

import io.kotlintest.matchers.startWith
import io.kotlintest.should
import io.kotlintest.shouldNotBe
import org.junit.jupiter.api.Disabled
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ArgumentsSource
import ru.itbasis.jvmwrapper.core.JvmVersion
import java.io.File

class OracleProviderIntegrationTest {
  @Disabled
  @ParameterizedTest
  @ArgumentsSource(value = JvmVersionSampleArgumentsProvider::class)
  fun `resolve and download archive`(jvmVersionSample: JvmVersionSample) {
    val oracleProvider = OracleProvider(JvmVersion(version = jvmVersionSample.version))

    val remoteArchiveFile = oracleProvider.remoteArchiveFile
    remoteArchiveFile shouldNotBe null
    remoteArchiveFile.url should startWith(jvmVersionSample.downloadArchiveUrlPart)

    val tempFile = File.createTempFile("tmp", "tmp")
    oracleProvider.download(remoteArchiveFile, tempFile)
  }
}
