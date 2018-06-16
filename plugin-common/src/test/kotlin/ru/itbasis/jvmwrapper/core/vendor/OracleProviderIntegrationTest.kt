package ru.itbasis.jvmwrapper.core.vendor

import io.kotlintest.data.forall
import io.kotlintest.matchers.startWith
import io.kotlintest.should
import io.kotlintest.shouldNotBe
import io.kotlintest.specs.FunSpec
import io.kotlintest.tables.row
import ru.itbasis.jvmwrapper.core.JvmVersion
import ru.itbasis.jvmwrapper.core.JvmVersionLatestSamples
import java.io.File

internal class OracleProviderIntegrationTest : FunSpec({
  test("resolve and download archive") {
    forall(
      rows = *JvmVersionLatestSamples.map { row(it) }.toTypedArray()
    ) { jvmVersionSample ->
      val oracleProvider = OracleProvider(JvmVersion(version = jvmVersionSample.version))

      val remoteArchiveFile = oracleProvider.remoteArchiveFile
      remoteArchiveFile shouldNotBe null
      remoteArchiveFile.url should startWith(jvmVersionSample.downloadArchiveUrlPart)

      val tempFile = File.createTempFile("tmp", "tmp")
      oracleProvider.download(remoteArchiveFile, tempFile)
    }
  }
})
